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
        # Add csv files to zip
        #
        def zip_all(destination)
          zip_file_path = "#{destination}/#{@campus_slug}.zip"
          zip_file = File.new(zip_file_path, 'w')

          Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
            csv_files.each do |file_name|
              zip.add(file_name, "#{@csv_dir}/#{file_name}")
            end
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
                values = [prep_number_for_excel(doc.get('id')), # not in attributes
                          prep_values(doc.get('campus').first), # move to front
                          prep_number_for_excel(doc.get('isPartOf').first), # move to front
                          prep_values(doc.get('visibility')), # not in attributes
                          prep_date_for_excel(doc.get('embargo_release_date')), # not in attributes
                          prep_values(doc.get('visibility_during_embargo')), # not in attributes
                          prep_values(doc.get('visibility_after_embargo')), # not in attributes
                          prep_values(doc.get('depositor')), # move to front
                          prep_values(doc.get('title_formatted')), # use formatted
                          prep_values(doc.get('description_formatted'))] # use formatted
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
            value = doc.get(attr)
            unless value.nil?
              value = prep_values(value)
              value = prep_person(value) if person_field?(attr)
              value = prep_date_for_excel(value) if date_field?(attr)
              value = prep_number_for_excel(value) if identifier_field?(attr)
            end
            values.append value
          end

          values
        end

        #
        # Gather the export files for a campus
        #
        # @return [Array]
        #
        def csv_files
          files = []

          Dir["#{@csv_dir}/#{@campus_slug}_*.csv"].each do |path|
            file = path.split('/').pop
            files.append file
          end

          files
        end
      end
    end
  end
end
