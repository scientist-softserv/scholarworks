# frozen_string_literal: true
#
# All models inherit from Hyrax::CoreMetadata, which includes:
#
# date_uploaded:	        ::RDF::Vocab::DC.dateSubmitted, multiple: false
# date_modified:	        ::RDF::Vocab::DC.modified, multiple: false
# depositor:	            ::RDF::URI.new('http://id.loc.gov/vocabulary/relators/dpt'), multiple: false
# title:	                ::RDF::Vocab::DC.title
#
# And also Hyrax::BasicMetadata, which includes:
#
# abstract	              ::RDF::Vocab::DC.abstract
# access_right	          ::RDF::Vocab::DC.accessRights
# alternative_title	      ::RDF::Vocab::DC.alternative
# based_near	            ::RDF::Vocab::FOAF.based_near, class_name: Hyrax::ControlledVocabularies::Location
# bibliographic_citation	::RDF::Vocab::DC.bibliographicCitation
# contributor	            ::RDF::Vocab::DC11.contributor
# creator	                ::RDF::Vocab::DC11.creator
# date_created	          ::RDF::Vocab::DC.created
# description	            ::RDF::Vocab::DC11.description
# identifier	            ::RDF::Vocab::DC.identifier
# import_url	            ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false
# keyword	                ::RDF::Vocab::SCHEMA.keywords
# label	                  ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false
# language	              ::RDF::Vocab::DC11.language
# license	                ::RDF::Vocab::DC.license
# publisher	              ::RDF::Vocab::DC11.publisher
# related_url	            ::RDF::RDFS.seeAlso
# relative_path	          ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false
# resource_type	          ::RDF::Vocab::DC.type
# rights_notes	          ::RDF::URI.new('http://purl.org/dc/elements/1.1/rights')
# rights_statement	      ::RDF::Vocab::EDM.rights
# source	                ::RDF::Vocab::DC.source
# subject	                ::RDF::Vocab::DC11.subject
#
# Shared metadata across all models
#
# See also BasicBehavior
#
module BasicFields
  extend ActiveSupport::Concern

  included do

    property :campus, predicate: ::RDF::Vocab::DC.publisher do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued_year, predicate: ::RDF::Vocab::SCHEMA.datePublished, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :description_note, predicate: ::RDF::Vocab::SCHEMA.description do |index|
      index.as :stored_searchable
    end

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable
    end

    property :external_id, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalID'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :external_modified_date, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalModifiedDate'), multiple: false do |index|
      index.as :stored_searchable, :sortable
    end

    property :external_system, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalSystem'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :external_url, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#externalUrl'), multiple: false do |index|
      index.as :stored_searchable
    end

    property :file_format, predicate: ::RDF::Vocab::DC.FileFormat do |index|
      index.as :stored_searchable, :facetable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable
    end

    property :internal_note, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#internalNote') do |index|
      index.as :stored_searchable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance do |index|
      index.as :stored_searchable
    end

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable
    end

    property :rights_note, predicate: ::RDF::Vocab::EBUCore.rightsExpression do |index|
      index.as :stored_searchable
    end

    property :file_type, predicate: ::RDF::URI.new('http://library.calstate.edu/ns#fileType') do |index|
      index.as :stored_searchable, :facetable
    end
  end
end
