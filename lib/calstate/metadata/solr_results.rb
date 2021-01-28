# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Solr results
    #
    class SolrResults
      # @return [Integer] starting record number
      attr_accessor :start

      # @return [Integer] number of records
      attr_accessor :total

      # @return [Array] array of json documents
      attr_accessor :records

      #
      # New SolrResults
      #
      # @param start [Integer]  starting record number
      # @param total [Integer]  number of records
      # @param records [Array]  [optional] array of json documents
      #
      def initialize(start, total, records = [])
        @start = start
        @total = total
        @records = records
      end

      #
      # The next record number to fetch
      #
      # @return [Integer]
      #
      def pointer
        @start + @records.length
      end
    end
  end
end
