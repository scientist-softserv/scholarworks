# frozen_string_literal: true

#
# Presentation
#
class Presentation < ActiveFedora::Base
  include ScholarworksFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = PresentationIndexer
  validates :title, presence: { message: 'Your work must have a title.' }
  # restrict which works can be added as a child.
  # self.valid_child_concerns = []

  property :meeting_name, predicate: ::RDF::Vocab::BIBO.presentedAt, multiple: false do |index|
    index.as :stored_searchable
  end

  property :place, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasLocation'), multiple: false do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include ScholarworksBehavior
  include FormattingBehavior
end
