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
end
