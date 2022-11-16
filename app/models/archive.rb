# frozen_string_literal: true

#
# Archive model
#
class Archive < ActiveFedora::Base
  include CsuFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = ArchiveIndexer
  validates :title, presence: { message: 'Your work must have a title.' }

  property :format, predicate: ::RDF::Vocab::DC.format do |index|
    index.as :stored_searchable
  end

  property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
    index.as :stored_searchable
  end

  property :has_finding_aid, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#hasFindingAid') do |index|
    index.as :stored_searchable
  end

  property :institution, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#institution') do |index|
    index.as :stored_searchable
  end

  property :interviewee, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/relators/ive') do |index|
    index.as :stored_searchable
  end

  property :interviewer, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/relators/ivr') do |index|
    index.as :stored_searchable
  end

  property :is_part_of, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#isPartOf') do |index|
    index.as :stored_searchable
  end

  property :repository, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#repository') do |index|
    index.as :stored_searchable
  end

  property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
    index.as :stored_searchable
  end

  property :work_type, predicate: ::RDF::Vocab::DC11.type do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior

  #
  # Before saving this work
  #
  def on_save
    set_year
  end
end
