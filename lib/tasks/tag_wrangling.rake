require 'csv'

namespace :tags do
  namespace :cleanup do
    task :events => :environment do
      def delete_tag(tag_id, tag_type)
        tag = Tag.where(:tag_id => tag_id, :tag_type => tag_type).first
        tag.delete if tag
      end

      def retag(old_tag, new_tag, tag_type)
        target = Artefact.with_tags([old_tag]).not_in(tag_ids: [new_tag])
        target.each do |a|
          # TODO check if other tags exist
          current_event_tags = a.tags_of_type(tag_type).map {|x| x.tag_id }.uniq
          new_event_tags = current_event_tags.map{ |t| t == old_tag ? new_tag : t}
          a.set_tags_of_type(tag_type, new_event_tags)
          a.save
        end
        # remove old tags
        delete_tag(old_tag, "event")
      end

      event_tags = {
        "lunchtime-lecture" => "event:lunchtime-lecture",
        "meetup" => "event:meetup",
        "research-afternoon" => "event:research-afternoon",
        "open-data-challenge-series" => "event:open-data-challenge-series",
        "roundtable" => "event:roundtable",
        "workshop" => "event:workshop",
        "networking-events" => "event:networking-events",
        "panel-discussions" => "event:panel-discussions"
      }
      event_tags.each { |k,v| retag k, v, "event"}
    end
  end

  task :batch => :environment do
    desc "Process batch update to tags. args = input file, output file (defaults = data/batch_tags.csv, ./batch_tags.log.csv)"
    logger.level=2

    def get_keywords(array, keys)
      # Return only those fields which correspond to a nil value
      array.each_with_index.map {|x,i| keys[i].nil? ? x : nil rescue nil }.compact
    end

    def get_or_create_tag tag_id
      tag_list = Tag.where({tag_id: tag_id.parameterize})
      if tag_list.count == 0
        # create a new tag, and return that
        tag = Tag.new(:tag_id => tag_id.parameterize)
        tag.update_attributes({ title: tag_id, tag_type: "keyword" })
        tag
      elsif tag_list.count > 1
        logger.warn "Duplicated tag #{tag_id}"
        tag_list.first
      else
        tag_list.first
      end
    end

    def update_tag artefact, tag
      existing_tags = artefact.tags_of_type(tag.tag_type).map {|t| t.tag_id}.uniq
      new_tags = existing_tags.append( tag.tag_id ).uniq
      artefact.set_tags_of_type(tag.tag_type, new_tags)
    end

    def report_on r_data, filename='batch_tags.log.csv'
      target = open(filename, 'w')
      r_data = r_data.map {|x| [x[:slug], x[:error], x[:tags].join(",")]}
      target.write ["slug", "error", "", "", "", ""].join ","
      target.write "\n"
      r_data.each do |row|
        target.write row.join ","
        target.write "\n"
      end
    end

    csv_data = CSV.read( ARGV[1] || "data/batch_tags.csv" )
    headings = csv_data[0].map {|x| x.nil? || x =~ /^keyword/ ? nil : x }
    data = csv_data.drop(1).map { |x| {:slug => x[headings.index("slug")], :tags => get_keywords(x, headings)} }

    # Iterate the data
    processed = []
    data.each do |x|
      artefact_list = Artefact.where({slug: x[:slug]})
      begin
        raise "Duplicate slug #{x[:slug]}" if artefact_list.length > 1
        raise "Missing slug #{x[:slug]}" if artefact_list.length == 0
        artefact = artefact_list.first
        x[:tags]
          .map {|tag_id| get_or_create_tag tag_id}
          .each {|tag| update_tag artefact, tag}
        artefact.save!
      rescue Mongoid::Errors::Validations => e
        x[:error] = "Can't save #{artefact.slug} (#{e.message})"
        logger.error x[:error]
      rescue RuntimeError => e
        x[:error] = "Can't process #{x[:slug]} (#{e.message})"
      ensure
        processed.append x
      end
    end
    report_on processed, ARGV[2] || "batch_tags.log.csv"
  end
end
