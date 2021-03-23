# frozen_string_literal: true

require 'csv'

module CalState
  module Metadata
    module Csv
      #
      # Methods for normalizing field values and file names
      #
      module Utilities
        #
        # Get value of a field as a string
        # If this is a multi-valued field,
        #
        # @param value
        # @param join [Boolean]  [optional] If this is a multi-valued field,
        #                        join them using pipe, otherwise return first
        #
        def get_value(value, join = false)
          if value.is_a?(ActiveTriples::Relation) || value.is_a?(Array)
            if join
              prep_value(value.join('|'))
            else
              prep_value(value.first)
            end
          else
            prep_value(value)
          end
        end

        #
        # Ensure that any value we extract doesn't have illegal characters
        # including any we supplied in the export to trick excel
        #
        # @param value[String]  the value to clean
        #
        # @return [String|nil] a nice shiny, clean value
        #
        def clean_value(value)
          value = value.to_s.squish
          return nil if value.empty?

          value
        end

        #
        # Convert value to string and append a tab to the end to force excel
        # to treat the field as text rather than a number or date
        #
        # @param value [String]  the value to add
        #
        # @return [String] the value plus tab at the end
        #
        def prep_value(value)
          value = clean_value(value)
          return nil if value.nil?

          value.to_s + "\t"
        end

        #
        # Get the model from the standard file name
        #
        # @param file_name [String]  the complete name of the metadata file
        #
        # @return [ActiveFedora::Base]
        #
        def get_model_from_file(file_name)
          name = File.basename(file_name, '.csv')
          parts = name.split('_')
          parts.shift # remove the campus name
          slug = parts.join('_')
          Metadata.get_model_from_slug(slug)
        end

        #
        # Get the model from the standard file name
        #
        # @param campus_slug [String]  campus identifier
        # @param model_name [String]   model name
        #
        # @return [String]
        #
        def get_csv_filename(campus_slug, model_name)
          model_file = Metadata.get_slug(model_name)
          campus_slug + '_' + model_file + '.csv'
        end
      end
    end
  end
end
