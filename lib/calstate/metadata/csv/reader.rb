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

        # @return [Array] cleaned array of records
        attr_reader :records

        #
        # New CSV Reader
        #
        # @param csv_file [String]  path to csv file
        #
        def initialize(csv_file)
          options = { headers: true, encoding: 'bom|utf-8' }
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

        protected

        #
        # Get all records, with cleaned values
        #
        # @param csv [CSV]  CSV object
        # @return [Array]
        #
        def load_records(csv)
          final = []
          csv.each do |row|
            record = {}
            row.each do |key, value|
              record[key] = clean_value(value)
            end
            final.append record
          end
          final
        end
      end
    end
  end
end
