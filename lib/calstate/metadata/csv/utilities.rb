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
        # Multi-value separator
        #
        def separator
          '|'
        end

        #
        # Prep multiple values for export
        #
        # If this is a multi-valued field, join them using pipe
        #
        # @param value  field value
        #
        # @return [String]
        #
        def prep_values(value)
          if value.is_a?(ActiveTriples::Relation) || value.is_a?(Array)
            prep_value(value.join(separator))
          else
            prep_value(value)
          end
        end

        #
        # Prepare single value for export
        #
        # Convert to string and append a tab to the end to force excel
        # to treat the field as text rather than a number or date
        #
        # @param value [String]  the value to add
        #
        # @return [String] the value
        #
        def prep_value(value)
          value = clean_value(value)
          return nil if value.nil?

          value.to_s
        end

        #
        # Ensure that any value we extract doesn't have illegal characters
        # including any we supplied in the export to trick excel
        #
        # @param value [String]  the value to clean
        #
        # @return [String|nil] a nice shiny, clean value
        #
        def clean_value(value)
          value = value.to_s.squish
          return nil if value.empty?

          value
        end

        #
        # Is the supplied field a person field?
        #
        # @param field [String]  field name
        #
        # @return [Boolean]
        #
        def is_person_field?(field)
          FieldService.person_fields.include?(field)
        end

        #
        # Prep person data for export
        #
        # @param person_data [Array|]
        #
        # @return [String]
        #
        def prep_person(person_data)
          return person_data if person_data.nil?

          final = []
          person_data.split(separator).each do |person_string|
            person = CompositeElement.new.from_hyrax(person_string)
            final.append person.to_export
          end
          final.join(separator)
        end

        #
        # Clean person data for import
        #
        # @param person_csv [String]
        #
        def clean_person(person_csv)
          person = CompositeElement.new.from_export(person_csv)
          person.to_hyrax
        end

        #
        # Is the supplied field a date field?
        #
        # @param field [String]  field name
        #
        # @return [Boolean]
        #
        def is_date_field?(field)
          FieldService.date_fields.include?(field)
        end

        #
        # Date fields should have a tab appended at the end
        # to keep excel from messing with dates
        #
        # @param value [String]
        #
        # @return [String]
        #
        def prep_date(value)
          return value if value.nil?

          value + "\t"
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
