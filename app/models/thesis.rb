# frozen_string_literal: true

#
# Thesis
#
class Thesis < ActiveFedora::Base
  include CsuFields
  include ScholarworksFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = ThesisIndexer
  validates :title, presence: { message: 'Your work must have a title.' }
  # restrict which works can be added as a child.
  # self.valid_child_concerns = []

  property :degree_level, predicate: ::RDF::Vocab::DC.educationLevel, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_name, predicate: ::RDF::Vocab::BIBO.degree do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_program, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#degree_program') do |index|
    index.as :stored_searchable
  end

  property :granting_institution, predicate: ::RDF::Vocab::MARCRelators.uvp do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior
  include ScholarworksBehavior

  #
  # Before saving this work
  #
  def on_save
    set_year
    set_college
    set_degree_level
    set_campus_publisher
  end

  #
  # Set the degree level based on the resource type
  #
  def set_degree_level
    service = DegreeLevelService.new(self.class.name.downcase)
    level = service.get(resource_type.first)
    self.degree_level = level unless level.nil?
  end

  #
  # Make the campus the publisher
  #
  def set_campus_publisher
    full_name = CampusService.get_full_from_name(campus.first)
    self.publisher = [full_name]
  end
end
