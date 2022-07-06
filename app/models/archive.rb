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

  property :accrual_method, predicate: ::RDF::Vocab::DC.accrualMethod do |index|
    index.as :stored_searchable
  end

  property :accrual_periodicity, predicate: ::RDF::Vocab::DC.accrualPeriodicity do |index|
    index.as :stored_searchable
  end

  property :accrual_policy, predicate: ::RDF::Vocab::DC.accrualPolicy do |index|
    index.as :stored_searchable
  end

  property :audience, predicate: ::RDF::Vocab::DC.audience do |index|
    index.as :stored_searchable
  end

  property :conforms_to, predicate: ::RDF::Vocab::DC.conformsTo do |index|
    index.as :stored_searchable
  end

  property :coverage, predicate: ::RDF::Vocab::DC.coverage do |index|
    index.as :stored_searchable
  end

  property :date_accepted, predicate: ::RDF::Vocab::DC.dateAccepted do |index|
    index.as :stored_searchable
  end

  property :date_modified, predicate: ::RDF::Vocab::DC.modified, multiple: false do |index|
    index.as :stored_searchable
  end

  property :date_valid, predicate: ::RDF::Vocab::DC.valid do |index|
    index.as :stored_searchable
  end

  property :description_note, predicate: ::RDF::Vocab::SCHEMA.description do |index|
    index.as :stored_searchable
  end

  property :education_level, predicate: ::RDF::Vocab::DC.educationLevel do |index|
    index.as :stored_searchable
  end

  property :format, predicate: ::RDF::Vocab::DC.format do |index|
    index.as :stored_searchable
  end

  property :has_format, predicate: ::RDF::Vocab::DC.hasFormat do |index|
    index.as :stored_searchable
  end

  property :has_part, predicate: ::RDF::Vocab::DC.hasPart do |index|
    index.as :stored_searchable
  end

  property :has_version, predicate: ::RDF::Vocab::DC.hasVersion do |index|
    index.as :stored_searchable
  end

  property :instructional_method, predicate: ::RDF::Vocab::DC.instructionalMethod do |index|
    index.as :stored_searchable
  end

  property :is_format_of, predicate: ::RDF::Vocab::DC.isFormatOf do |index|
    index.as :stored_searchable
  end

  property :is_referenced_by, predicate: ::RDF::Vocab::DC.isReferencedBy do |index|
    index.as :stored_searchable
  end

  property :is_replaced_by, predicate: ::RDF::Vocab::DC.isReplacedBy do |index|
    index.as :stored_searchable
  end

  property :is_required_by, predicate: ::RDF::Vocab::DC.isRequiredBy do |index|
    index.as :stored_searchable
  end

  property :is_version_of, predicate: ::RDF::Vocab::DC.isVersionOf do |index|
    index.as :stored_searchable
  end

  property :mediator, predicate: ::RDF::Vocab::DC.mediator do |index|
    index.as :stored_searchable
  end

  property :medium, predicate: ::RDF::Vocab::DC.medium do |index|
    index.as :stored_searchable
  end

  property :references, predicate: ::RDF::Vocab::DC.references do |index|
    index.as :stored_searchable
  end

  property :relation, predicate: ::RDF::Vocab::DC.relation do |index|
    index.as :stored_searchable
  end

  property :replaces, predicate: ::RDF::Vocab::DC.replaces do |index|
    index.as :stored_searchable
  end

  property :requires, predicate: ::RDF::Vocab::DC.requires do |index|
    index.as :stored_searchable
  end

  property :rights_access, predicate: ::RDF::Vocab::DC.accessRights do |index|
    index.as :stored_searchable
  end

  property :table_of_contents, predicate: ::RDF::Vocab::DC.tableOfContents do |index|
    index.as :stored_searchable
  end

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior
end
