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
      # @param [Integer] start  starting record number
      # @param [Integer] total  number of records
      # @param [Array] records  [optional] array of json documents
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
