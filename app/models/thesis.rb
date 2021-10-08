# Generated via
#  `rails generate hyrax:work Thesis`
class Thesis < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::CsuMetadata
  include ::Hydra::AccessControls::CampusVisibility

  before_create :update_fields

  self.indexer = ThesisIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :creator, presence: { message: 'Your work must have an author.' }

  property :advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
    index.as :stored_searchable
  end

  property :committee_member, predicate: ::RDF::Vocab::MARCRelators.ctb do |index|
    index.as :stored_searchable
  end

  property :degree_level, predicate: ::RDF::Vocab::DC.educationLevel, multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :degree_name, predicate: ::RDF::Vocab::BIBO.degree do |index|
    index.as :stored_searchable, :facetable
  end

  property :granting_institution, predicate: ::RDF::Vocab::MARCRelators.uvp do |index|
    index.as :stored_searchable
  end

  property :resource_type_thesis, predicate: ::RDF::Vocab::DC.type do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  def creator
    OrderedStringHelper.deserialize(super)
  end

  def creator= values
    super sanitize_n_serialize(values)
  end

  def advisor
    OrderedStringHelper.deserialize(super)
  end

  def advisor= values
    super sanitize_n_serialize(values)
  end

  def committee_member
    OrderedStringHelper.deserialize(super)
  end

  def committee_member= values
    super sanitize_n_serialize(values)
  end

  # this method is to combined all multivalues of this field into a single one for the front end
  def descriptions
    combined_val = ''
    description.each do |d|
      combined_val << d
    end
    combined_val
  end

  def update_fields

  end
end
