# frozen_string_literal: true

require 'csv'

module CalState
  module Metadata
    module Csv
      #
      # Simple metadata updater
      #
      class Fixer
        #
        # New simple metadata fixer
        #
        # @param campus_name [String]  campus full name
        # @param model [String]        [optional] model to limit to
        #
        def initialize(campus_name, model = '')
          @campus_name = campus_name
          @model_types = if model.empty?
                           CalState::Metadata.models
                         else
                           CalState::Metadata.get_model_from_slug(model)
                         end
        end

        #
        # Update records with supplied spreadsheet
        #
        # @param csv_file [String]  path to csv file
        #
        def replace_metadata(csv_file)
          # get metadata file
          metadata = load_csv_file(csv_file)
          raise 'No metadata to replace' if metadata.empty?

          @model_types.each do |model|
            model.where(campus: @campus_name).each do |doc|
              need_update = false
              metadata.each do |m|
                begin
                  found = false
                  field_name = m['field']
                  field_values = doc[field_name].dup # throw ArgumentError if no such field_name

                  # do the replacement or get rid of
                  replace_field_values = []
                  field_values.each do |field_value|
                    next if field_value.nil? or field_value.empty?

                    field_value = clean_field(field_value)
                    if field_value.eql?(m['look_for']) && !m['to_replace'].nil? && !m['to_replace'].empty?
                      found = true
                      need_update = true
                      replace_field_values << m['to_replace']
                    else
                      replace_field_values << field_value
                    end
                  end
                  doc[field_name] = replace_field_values if found
                rescue ArgumentError => e
                  p e.message
                end
              end

              doc.save if need_update
            end
          end
        end

        private

        #
        # Load the input spreadsheet
        #
        # @param csv_file [String]  path to csv file
        #
        # @return [Array]
        #
        def load_csv_file(csv_file)
          metadata = []
          CSV.foreach(csv_file) do |row|
            next if row.length < 2

            value = {}
            value['field'] = row[0]
            value['look_for'] = row[1]
            value['to_replace'] = row[2]
            metadata << value
          end

          metadata
        end
      end
    end
  end
end
