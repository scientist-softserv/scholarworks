# frozen_string_literal: true

require 'csv'

module CalState
  module Metadata
    module Csv
      #
      # CSV Reader
      #
      class Reader
        include Utilities

        #
        # Cleaned array of records
        #
        # @return [Array]
        #
        attr_reader :records

        #
        # File path
        #
        # @return [String]
        #
        attr_reader :file

        #
        # New CSV Reader
        #
        # @param csv_file [String]        path to csv file
        # @param tab_separated [Boolean]  [optional] whether file is tab separated
        #
        def initialize(csv_file, tab_separated = false)
          @file = csv_file
          options = {
            headers: true,
            encoding: 'bom|utf-8',
            liberal_parsing: true
          }
          options[:col_sep] = "\t" if tab_separated
          @csv = CSV.read(csv_file, options)
          @records = load_records(@csv)
        end

        #
        # Get a subset of records
        #
        # @param args [Hash]  field: value
        #
        # @return [Array]
        #
        def query(**args)
          results = []
          @records.each do |record|
            match = true
            args.each do |key, value|
              match = false unless record[key.to_s] == value
            end
            results.append record if match
          end
          results
        end

        #
        # Get all records, with cleaned values
        #
        # @param csv [CSV]  CSV object
        # @return [Array<Hash>]
        #
        def load_records(csv)
          final = []
          csv.each do |row|
            record = {}
            row.each do |key, value|
              value = clean_value(value)
              if FieldService.single_fields.include?(key)
                record[key] = value
              else
                values = value.to_s.split(separator)
                if FieldService.person_fields.include?(key)
                  persons = []
                  values.each do |person|
                    persons.append clean_person(person)
                  end
                  values = persons
                end
                record[key] = values
              end
            end
            final.append record
          end
          final
        end

        #
        # Records as XML
        #
        # @return [Nokogiri::XML::Document]
        #
        def to_xml
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.records {
              x = 0
              @records.each do |record|
                x += 1
                id = record['id'] ||= ''
                xml.record(id: id, counter: x) {
                  record.each do |field, value|
                    xml.field(name: field) {
                      if value.is_a?(Array)
                        xml.value(multi: true) {
                          value.each do |part|
                            xml.part part
                          end
                        }
                      else
                        xml.value(value, type: 'new')
                      end
                    }
                  end
                }
              end
            }
          end

          Nokogiri::XML::Document.parse(builder.to_xml)
        end
      end
    end
  end
end
