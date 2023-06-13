# frozen_string_literal: true
#
# Shared metadata across ScholarWorks models
#
# See also ScholarWorksBehavior
#
module ScholarworksFields
  extend ActiveSupport::Concern

  included do

    # @deprecated
    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable
    end

    property :advisor, predicate: ::RDF::Vocab::MARCRelators.ths do |index|
      index.as :stored_searchable
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

    # @deprecated
    property :date_submitted, predicate: ::RDF::Vocab::SCHEMA.Date do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :discipline, predicate: ::RDF::Vocab::DC.subject do |index|
      index.as :stored_searchable, :facetable
    end

    property :doi, predicate: ::RDF::Vocab::SCHEMA.identifier do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :embargo_terms, predicate: ::RDF::Vocab::DC.description, multiple: true do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :identifier_uri, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/identifiers/uri') do |index|
      index.as :stored_searchable
    end

    property :isbn, predicate: ::RDF::Vocab::SCHEMA.isbn do |index|
      index.as :stored_searchable
    end

    property :issn, predicate: ::RDF::Vocab::SCHEMA.issn do |index|
      index.as :stored_searchable
    end

    property :oclcno, predicate: ::RDF::Vocab::BIBO.oclcnum do |index|
      index.as :stored_searchable
    end

    property :place, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasLocation'), multiple: false do |index|
      index.as :stored_searchable
    end

    # @deprecated
    property :publication_status, predicate: ::RDF::Vocab::BIBO.status, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :publication_title, predicate: ::RDF::Vocab::DC.relation do |index|
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
