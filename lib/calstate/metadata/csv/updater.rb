# frozen_string_literal: true

require 'csv'

module CalState
  module Metadata
    module Csv
      #
      # CSV Updater
      #
      class Updater
        include Utilities
        include Metadata::Utilities

        #
        # Update records for a given model
        #
        # @param [String] csv_file  path to csv file
        #
        def update_records(csv_file)
          tasks = {}

          model = get_model_from_file(csv_file)
          fields = model.attribute_names

          csv = Reader.new(csv_file)
          csv.records.each do |row|
            begin
              id = row['id']
              doc = model.find(id)
            rescue StandardError => e
              puts 'ERROR: ' + e.to_s
              next
            end

            task = []
            row.each do |key, value|
              next unless fields.include? key

              result = compare_value(doc, key, value)
              task << result unless result.blank?
            end
            next if task.empty?

            puts "\n\n------------------------------"
            puts doc.id + ': ' + doc.title.first.to_s
            task.each do |message|
              puts message
            end

            tasks[id] = task
          end
        end

        protected

        #
        # Compare the value in the Fedora document
        #
        # @param [ActiveFedora::Base] doc the fedora document
        # @param [String] key         the field name
        # @param [String] value       the value to compare
        #
        def compare_value(doc, key, value)
          doc_field = doc[key]
          return if doc_field.blank? && value.blank?

          diff = if doc_field.is_a?(ActiveTriples::Relation)
                   doc_values = field_to_array(doc_field)
                   csv_values = value.blank? ? [] : value.split('|')

                   doc_value = doc_values.sort.join('|') + "\n"
                   csv_value = csv_values.sort.join('|') + "\n"

                   Diffy::Diff.new(doc_value, csv_value)
                 else
                   Diffy::Diff.new(doc_field.to_s + "\n", value.to_s + "\n")
                 end

          return nil if diff.to_s.length.zero?

          key + ":\n" + diff.to_s
        end
      end
    end
  end
end
