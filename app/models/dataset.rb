# frozen_string_literal: true

#
# Dataset
#
class Dataset < ActiveFedora::Base
  include CsuFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = DatasetIndexer
  validates :title, presence: { message: 'Your work must have a title.' }
  # restrict which works can be added as a child.
  # self.valid_child_concerns = []

  property :award_number, predicate: ::RDF::Vocab::SCHEMA.award do |index|
    index.as :stored_searchable
  end

  property :data_note, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#dataNote') do |index|
    index.as :stored_searchable
  end

  property :data_type, predicate: ::RDF::Vocab::MODS.partType do |index|
    index.as :stored_searchable
  end

  property :date_range, predicate: ::RDF::Vocab::SCHEMA.temporalCoverage

  property :date_last_modified, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#dateLastModified') do |index|
    index.as :stored_searchable
  end

  property :methods_of_collection, predicate: ::RDF::Vocab::BIBO.shortDescription

  # @deprecated
  property :investigator, predicate: ::RDF::Vocab::MARCRelators.org do |index|
    index.as :stored_searchable
  end

  def save(*options)
    self.resource_type = ['Dataset']
    super(*options)
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior
end
