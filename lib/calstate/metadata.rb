# frozen_string_literal: true

require_relative 'metadata/utilities'
require_relative 'metadata/csv'
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
    # Mapping of models defined in ScholarWorks
    #
    # @return [Hash]  slug: model name
    #
    def self.model_mapping
      mapping = {}
      Hyrax.config.registered_curation_concern_types.each do |type|
        mapping[type.underscore.to_sym] = type
      end
      mapping
    end

    #
    # The names of the models defined in ScholarWorks
    #
    # @return [Array<String>]  of model class names
    #
    def self.model_names
      model_mapping.values
    end

    #
    # Models defined in ScholarWorks
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

    #
    # Get slug for model name
    #
    # @param model_name [String]  the model name
    #
    # @return [String]
    #
    def self.get_slug(model_name)
      unless model_mapping.value?(model_name)
        raise 'No slug defined for ' + model_name
      end

      model_mapping.key(model_name).to_s
    end

    #
    # Model for given slug
    #
    # @param slug [String]  the model slug
    #
    # @return [ActiveFedora::Base]
    #
    def self.get_model_from_slug(slug)
      key = slug.to_sym
      raise 'No model defined for ' + slug unless model_mapping.key?(key)

      Kernel.const_get(model_mapping[key])
    end

    #
    # Get mapping of resource types to model
    #
    # @return [Hash]
    #
    def self.model_type_map
      return @type_map unless @type_map.nil?

      @type_map = {}
      model_names.each do |model|
        model_ext = model.downcase
        file = "#{Rails.root}/config/authorities/resource_types_#{model_ext}.yml"
        if File.exist?(file)
          yaml_file = OpenStruct.new(YAML.load_file(file))
          yaml_file.terms.each do |term|
            @type_map[term['id']] = model
          end
        else
          @type_map[model] = model
        end
      end

      @type_map
    end
  end
end
