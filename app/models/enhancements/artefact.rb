require "artefact"
require_relative "artefact/filter_scopes"

class Artefact
  include Artefact::FilterScopes

  # Add a non-field attribute so we can pass indexable content over to Rummager
  # without persisting it
  attr_accessor :indexable_content

  STATES = [ "live", "draft", "archived" ]
  ODI_FORMATS = [
    "creative_work",
    "case_study",
    "course",
    "course_instance",
    "event",
    "node",
    "person",
    "report",
    "organization",
    "article",
    "timed_item",
    "faq",
    "job"
  ]

  MASLOW_NEED_ID_LOWER_BOUND = 100000

  def self.relatable_items
  self.in_alphabetical_order
      .where(:kind.ne => "completed_transaction", :state.ne => "archived")
      .only(:name, :kind, :tag_ids)
  end

  def artefact_type
    begin
      self.send("#{self.kind}").first.title
    rescue
      self.kind
    end
  end

  def select_title
    @select_title ||= "#{name} (#{artefact_type})"
  end

  def need_id_editable?
    # allow the Need ID to be edited if:
    # - it's a new record
    # - the need ID is blank
    # - the need ID is not a number
    # - the need is a Need-o-tron need
    #
    self.new_record? ||
      self.need_id.blank? ||
      ! self.need_id_numeric? ||
      self.need_owning_service == "needotron"
  end

  def need_id_numeric?
    self.need_id.strip =~ /\A\d+\z/
  end

  def need_owning_service
    return nil unless self.need_id.present? and self.need_id.match(/\A[0-9]+\Z/)
    self.need_id.to_i < MASLOW_NEED_ID_LOWER_BOUND ? "needotron" : "maslow"
  end

  def need
    return unless need_owning_service == "maslow"

    @need ||= Panopticon.need_api.need(need_id)
  rescue GdsApi::BaseError
  end
end
