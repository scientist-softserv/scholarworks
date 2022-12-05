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
          @campus_name = CampusService.get_name_from_slug(campus_slug)
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
          column_names = %w[id
                            campus
                            admin_set_id
                            date_uploaded
                            visibility
                            embargo_release_date
                            visibility_during_embargo
                            visibility_after_embargo
                            depositor
                            title
                            description]

          # attributes from fedora
          attribute_names = get_fedora_attr(model)

          # remove formatted columns from attributes, since we handle these differently below
          attribute_names -= %w[title
                                title_formatted
                                description
                                description_formatted]

          # remove these from attributes, since we're adding them to front
          attribute_names -= %w[admin_set_id
                                campus]

          column_names.push(*attribute_names)

          # csv file
          csv_filename = get_csv_filename(@campus_slug, model_name)
          csv_file = "#{@csv_dir}/#{csv_filename}"

          CSV.open(csv_file, 'wb') do |csv|
            csv.to_io.write "\uFEFF"
            csv << column_names
            model.where(campus: @campus_name).each do |doc|
              begin
                values = [prep_value(doc.id), # not in attributes
                          prep_value(doc.campus.first), # move to front
                          prep_value(doc.admin_set_id), # move to front
                          prep_value(doc.date_uploaded), # not in attributes
                          prep_value(doc.visibility), # not in attributes
                          prep_value(doc.embargo_release_date), # not in attributes
                          prep_value(doc.visibility_during_embargo), # not in attributes
                          prep_value(doc.visibility_after_embargo), # not in attributes
                          prep_value(doc.depositor), # not in attributes
                          prep_values(doc.title_formatted), # use formatted
                          prep_values(doc.description_formatted)] # use formatted
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
        # Get Fedora attributes, minus internal fields
        #
        # @param model [ActiveFedora::Base]
        #
        # @return [Array]
        #
        def get_fedora_attr(model)
          model.attribute_names - FieldService.fedora
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
            value = prep_date(value) if is_date_field?(key)

            values << value
          end
          values
        end
      end
    end
  end
end
