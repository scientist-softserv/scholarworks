# frozen_string_literal: true

require_relative 'metadata/utilities'
require_relative 'metadata/dspace'
require_relative 'metadata/handle_mapper'
require_relative 'metadata/sitemap'
require_relative 'metadata/solr_reader'
require_relative 'metadata/solr_results'

module CalState
  #
  # Classes and functions for metadata remediation tasks
  #
  module Metadata
    #
    # The names of the models defined in ScholarWorks
    #
    # @return [Array<String>]  of model class names
    #
    def self.model_names
      %w[Thesis Publication Dataset EducationalResource]
    end

    #
    # The models defined in ScholarWorks
    #
    # @return [Array<ActiveRecord::Base>]  of models
    #
    def self.models
      model_array = []
      model_names.each do |model_name|
        model_array.append Kernel.const_get(model_name)
      end
      model_array
    end
  end
end
