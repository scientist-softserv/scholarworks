# frozen_string_literal: true

# All models inherit from Hyrax::BasicMetadata, which includes:
#
# based_near               ::RDF::Vocab::FOAF.based_near
# bibliographic_citation   ::RDF::Vocab::DC.bibliographicCitation
# creator                  ::RDF::Vocab::DC11.creator
# contributor              ::RDF::Vocab::DC11.contributor
# date_created             ::RDF::Vocab::DC.created
# description              ::RDF::Vocab::DC11.description
# identifier               ::RDF::Vocab::DC.identifier
# import_url               ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl')
# language                 ::RDF::Vocab::DC11.language
# keyword                  ::RDF::Vocab::DC11.relation
# license                  ::RDF::Vocab::DC.rights
# publisher                ::RDF::Vocab::DC11.publisher
# related_url              ::RDF::RDFS.seeAlso
# relative_path            ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath')
# resource_type            ::RDF::Vocab::DC.type
# rights_statement         ::RDF::Vocab::EDM.rights
# source                   ::RDF::Vocab::DC.source
# subject                  ::RDF::Vocab::DC11.subject

#
# Base class for shared metadata across all models
#
# See also CsuBehavior
#
module CsuFields
  extend ActiveSupport::Concern

  included do

    # @deprecated
    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable
    end

    property :advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
      index.as :stored_searchable
    end

    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative do |index|
      index.as :stored_searchable
    end

    property :campus, predicate: ::RDF::Vocab::DC.publisher do |index|
      index.as :stored_searchable, :facetable
    end

    property :college, predicate: ::RDF::Vocab::SCHEMA.CollegeOrUniversity do |index|
      index.as :stored_searchable, :facetable
    end

    property :committee_member, predicate: ::RDF::Vocab::MARCRelators.ctb do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :date_accessioned, predicate: ::RDF::Vocab::DC.date, multiple: false do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :date_available, predicate: ::RDF::Vocab::DC.available do |index|
      index.as :stored_searchable, :facetable
    end

    # @deprecated
    property :date_copyright, predicate: ::RDF::Vocab::DC.dateCopyrighted do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued_year, predicate: ::RDF::Vocab::SCHEMA.datePublished, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    # @deprecated
    property :date_submitted, predicate: ::RDF::Vocab::SCHEMA.Date do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :description_note, predicate: ::RDF::Vocab::SCHEMA.description do |index|
      index.as :stored_searchable
    end

    property :discipline, predicate: ::RDF::Vocab::DC.subject do |index|
      index.as :stored_searchable, :facetable
    end

    property :doi, predicate: ::RDF::Vocab::SCHEMA.identifier do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :embargo_terms, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
      index.as :stored_searchable
    end

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable
    end

    property :external_id, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalID'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :external_system, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalSystem'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :external_modified_date, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalModifiedDate'), multiple: false do |index|
      index.as :stored_searchable, :sortable
    end

    # @deprecated
    property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :identifier_uri, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/identifiers/uri') do |index|
      index.as :stored_searchable
    end

    property :internal_note, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#internalNote') do |index|
      index.as :stored_searchable
    end

    property :is_part_of, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#isPartOf') do |index|
      index.as :stored_searchable
    end

    property :isbn, predicate: ::RDF::Vocab::SCHEMA.isbn do |index|
      index.as :stored_searchable
    end

    property :issn, predicate: ::RDF::Vocab::SCHEMA.issn do |index|
      index.as :stored_searchable
    end

    property :license, predicate: ::RDF::Vocab::DC.license do |index|
      index.as :stored_searchable, :facetable
    end

    property :oclcno, predicate: ::RDF::Vocab::BIBO.oclcnum do |index|
      index.as :stored_searchable
    end

    property :place, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasLocation'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :publication_status, predicate: ::RDF::Vocab::BIBO.status, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :publication_title, predicate: ::RDF::Vocab::DC.relation do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
      index.as :stored_searchable
    end

    property :rights_note, predicate: ::RDF::Vocab::EBUCore.rightsExpression do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :rights_uri, predicate: ::RDF::URI.new('http://purl.org/dc/elements/1.1/rights') do |index|
      index.as :stored_searchable
    end

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable
    end

    property :statement_of_responsibility, predicate: ::RDF::Vocab::MARCRelators.rpy do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :time_period, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
