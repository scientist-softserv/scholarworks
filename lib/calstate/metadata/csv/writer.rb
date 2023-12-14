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
          # add these fields to the front of the array so we can
          # handle them differently, see below as to why
          column_names = %w[id
                            campus
                            admin_set_id
                            visibility
                            embargo_release_date
                            visibility_during_embargo
                            visibility_after_embargo
                            depositor
                            title
                            description]

          # attributes from fedora
          attribute_names = get_fedora_attr(model_name)

          # remove formatted columns from attributes, since we handle these differently below
          attribute_names -= %w[title
                                title_formatted
                                description
                                description_formatted]

          # remove fields we just use for internal purposes
          attribute_names -= FieldService.internal_fields

          # remove these from attributes, since we're adding them to front
          attribute_names -= %w[admin_set_id
                                campus
                                depositor]

          attribute_names.sort!
          column_names.push(*attribute_names)

          # csv file
          csv_filename = get_csv_filename(@campus_slug, model_name)
          csv_file = "#{@csv_dir}/#{csv_filename}"

          CSV.open(csv_file, 'wb') do |csv|
            csv.to_io.write "\uFEFF"
            csv << column_names

            solr = CalState::Metadata::Solr::Reader.new(campus: @campus_name, models: [model_name])

            solr.records.each do |doc|
              begin
                doc = convert_to_model(doc)
                values = [prep_number_for_excel(doc['id']), # not in attributes
                          prep_values(doc['campus'].first), # move to front
                          prep_number_for_excel(doc['isPartOf'].first), # move to front
                          prep_values(doc['visibility']), # not in attributes
                          prep_date_for_excel(doc['embargo_release_date']), # not in attributes
                          prep_values(doc['visibility_during_embargo']), # not in attributes
                          prep_values(doc['visibility_after_embargo']), # not in attributes
                          prep_values(doc['depositor']), # move to front
                          prep_values(doc['title_formatted']), # use formatted
                          prep_values(doc['description_formatted'])] # use formatted
                values.push(*get_attr_values(doc, attribute_names))
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
        # @param model_name ActiveFedora model name
        #
        # @return [Array]
        #
        def get_fedora_attr(model_name)
          model = Kernel.const_get(model_name)
          model.attribute_names - FieldService.fedora
        end

        #
        # Extract the values from this record
        #
        # @param doc [Hash]               Solr doc
        # @param attribute_names [Array]  the attributes we want to extract
        #
        # @return [Array] extracted values
        #
        def get_attr_values(doc, attribute_names)
          values = []

          attribute_names.each do |attr|
            value = nil
            if doc.key?(attr)
              value = prep_values(doc[attr])
              value = prep_person(value) if person_field?(attr)
              value = prep_date_for_excel(value) if date_field?(attr)
              value = prep_number_for_excel(value) if identifier_field?(attr)
            end
            values.append value
          end

          values
        end

        #
        # Convert Solr hash keys to field names without suffix
        #
        # @param doc [Hash]          Solr document
        #
        # @return [Hash]
        #
        def convert_to_model(doc)
          final = {}

          doc.each do |field, value|
            attr = if field.include?('_')
                     parts = field.split('_')
                     parts.pop
                     parts.join('_')
                   else
                     field
                   end
            final[attr] = value
          end

          final
        end
      end
    end
  end
end
