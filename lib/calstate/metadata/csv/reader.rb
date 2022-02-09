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
      end
    end
  end
end
