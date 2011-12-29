class RelatedItem < ActiveRecord::Base
  belongs_to :source_artefact, :class_name => 'Artefact'
  belongs_to :artefact, :counter_cache => true
end
