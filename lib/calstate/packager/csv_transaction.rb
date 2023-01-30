# frozen_string_literal: true

module CalState
  module Packager
    #
    # CSV transaction
    #
    class CsvTransaction
      #
      # New Csv packager
      #
      # @param csv [CalState::Metadata::Csv::Reader]
      #
      def initialize(csv)
        @file = File.dirname(csv.file) + '/' +
                File.basename(csv.file, '.csv') + '.xml'
        @doc = load_xml(@file, csv)
      end

      #
      # Get record at given position
      #
      # @param pos [Integer]
      #
      # @return Nokogiri::XML::Element
      #
      def record(pos)
        @doc.xpath("//record[@counter = '#{pos.to_s}']").each do |record|
          return record
        end

        raise 'Could not find record position ' + pos.to_s
      end

      #
      # Has the record already been processed?
      #
      # @return [Boolean]
      #
      def completed?(pos)
        record = record(pos)
        record['result'] == 'success'
      end

      #
      # Save transaction
      #
      def save
        File.write(@file, @doc)
      end

      private

      #
      # Load XML file
      #
      # Creates one if it doesn't exist
      #
      # @param file [String]
      # @param csv [CalState::Metadata::Csv::Reader]
      #
      def load_xml(file, csv)
        if File.exist?(file)
          Nokogiri::XML(File.open(file))
        else
          xml = csv.to_xml
          File.write(file, xml)
          xml
        end
      end
    end
  end
end
