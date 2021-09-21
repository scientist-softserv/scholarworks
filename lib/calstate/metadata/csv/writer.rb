# frozen_string_literal: true

require 'csv'

module CalState
  module Metadata
    module Csv
      #
      # CSV Writer
      #
      class Writer
        include Utilities

        #
        # New CSV Writer
        #
        # @param csv_dir [String]      path to csv directory
        # @param campus_slug [String]  campus slug
        #
        def initialize(csv_dir, campus_slug)
          @csv_dir = csv_dir
          @campus_slug = campus_slug
          @campus_name = Hyrax::CampusService.get_campus_name_from_id(campus_slug)
        end

        #
        # Write out files for all models
        #
        def write_all
          Metadata.model_names.each do |model|
            write_file(model)
          end
        end

        #
        # Write out file for specified model
        #
        # @param model_name [String]  the model name
        #
        def write_file(model_name)
          model = Kernel.const_get(model_name)

          # add these fields to the front of the array so we can
          # handle them differently, see below as to why
          special_columns = %w[id campus admin_set_id visibility
                               embargo_release_date visibility_during_embargo
                               visibility_after_embargo]

          column_names = special_columns

          # attributes from fedora
          attribute_names = get_columns(model.attribute_names)
          column_names.push(*attribute_names)

          # csv file
          csv_filename = get_csv_filename(@campus_slug, model_name)
          csv_file = @csv_dir + '/' + csv_filename

          CSV.open(csv_file, 'wb') do |csv|
            csv.to_io.write "\uFEFF" # BOM forces excel to treat file as UTF-8
            csv << column_names
            model.where(campus: @campus_name).each do |doc|
              begin
                values = [prep_value(doc.id), # not in attributes
                          prep_value(doc.campus.first), # move to front
                          prep_value(doc.admin_set_id), # move to front
                          prep_value(doc.visibility), # not in attributes
                          prep_value(doc.embargo_release_date), # not in attributes
                          prep_value(doc.visibility_during_embargo), # not in attributes
                          prep_value(doc.visibility_after_embargo)] # not in attributes
                values.push(*get_attr_values(doc.attributes, attribute_names))
                csv << values
              rescue ActiveFedora::ConstraintError => e
                puts e.message
              end
            end
          end
        end

        protected

        #
        # Determine the columns to include in the export
        #
        # @param column_names [Array]  all the attribute names from the fedora model
        #
        # @return [Array] only the approved columns
        #
        def get_columns(column_names)
          # remove internal fedora fields
          columns_remove = %w[head tail arkivo_checksum owner access_control_id
                              state representative_id thumbnail_id rendering_ids
                              embargo_id lease_id relative_path import_url]
          # remove scholarworks utility fields
          columns_remove += %w[resource_type_thesis resource_type_educationalresource
                               resource_type_dataset resource_type_publication]
          # remove columns we want to shift to the front, and will handle separately
          columns_remove += %w[campus admin_set_id]
          column_names - columns_remove
        end

        #
        # Extract the values from this record
        #
        # @param attributes [Hash]        all the attributes from the fedora record
        # @param attribute_names [Array]  the attributes we want to extract
        #
        # @return [Array] extracted values
        #
        def get_attr_values(attributes, attribute_names)
          values = []
          attributes.each do |key, value|
            next unless attribute_names.include?(key)

            value = prep_values(value)
            value = prep_person(value) if is_person_field?(key)
            values << value
          end
          values
        end
      end
    end
  end
end
