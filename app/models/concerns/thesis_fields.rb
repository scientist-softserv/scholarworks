# frozen_string_literal: true

#
# Shared metadata for Thesis & Project
#
# See also ThesisBehavior
#
module ThesisFields
  extend ActiveSupport::Concern

  included do
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
  end
end
