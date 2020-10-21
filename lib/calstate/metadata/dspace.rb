# frozen_string_literal: true

module CalState
  module Metadata
    #
    # DSpace metadata file reader
    #
    class Dspace
      # @return [Hash] records
      attr_reader :records

      #
      # New DSpace metadata file reader
      #
      # @param [String] csv_file      path to dspace csv file
      # @param [Hash] field_map       hyrax_field: dspace_field mapping
      # @param [String] handle_field  [optional] dspace field containing handle
      #
      # @return [Hash] as handle => values
      #
      def initialize(csv_file, field_map, handle_field = 'dc.identifier.uri')
        @records = {}
        table = CSV.parse(File.read(csv_file), headers: true)
        table.each do |row|
          values = {}
          field_map.each do |hyrax_field, dspace_field|
            values[hyrax_field] = extract_single_value(row, dspace_field)
          end
          values[:handle] = extract_single_value(row, handle_field)
          @records[values[:handle]] = values
        end
      end

      #
      # Extract all values from a dspace field without regard to language
      #
      # @param [Array] row      row of item values
      # @param [String] field   dspace field name
      #
      # @return [Array]
      #
      def extract_values(row, field)
        values = []
        ['', '[]', '[en]', '[en_US]'].each do |attr|
          values << row[field + attr] unless row[field + attr].nil?
        end
        values
      end

      #
      # Extract a single value from dspace field without regard to language
      #
      # @param [Array] row      row of item values
      # @param [String] field   dspace field name
      #
      # @return [String]
      #
      def extract_single_value(row, field)
        values = extract_values(row, field)
        return nil unless values.count.positive?

        values.first
      end
    end
  end
end
