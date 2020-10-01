# frozen_string_literal: true

require 'httparty'

module CalState
  module Metadata
    #
    # Fast Solr read-only queries for all metadata records
    #
    class SolrReader
      include Mapping
      #
      # New SolrReader
      #
      def initialize
        @solr_url = ENV['SOLR_URL'] + '/select'
      end

      #
      # Solr query to retrieve all open, unsuppressed records
      #
      # @return [String] Solr query
      #
      def query
        models_query = []
        model_names.each do |model|
          models_query.push 'has_model_ssim:' + model
        end
        '(' + models_query.join(' OR ') + ') ' \
          'AND suppressed_bsi:false AND visibility_ssi:open'
      end

      #
      # Solr parameters for paging
      #
      # @param [Integer] start  starting record position (default: 0)
      # @param [Integer] rows   number of rows to return (default: 1,000)
      #
      # @return [Hash] parameters, with query and wt: json
      #
      def params(start = 0, rows = 1000)
        {
          q: query,
          start: start,
          rows: rows,
          wt: 'json'
        }
      end

      #
      # Fetch all metadata records from the repository
      #
      # @return [Array] of Solr documents
      #
      def fetch_all
        start = 0
        results = []

        loop do
          results_batch = fetch_batch(start)
          results_batch.records.each do |result|
            results << result
          end

          start = results_batch.pointer
          break if results_batch.total <= start
        end

        results
      end

      #
      # Fetch a batch of records
      #
      # @param [Integer] start  [optional] starting record number
      # @param [Integer] rows   [optional] number of rows to fetch
      #
      # @return [SolrResults]
      #
      def fetch_batch(start = 0, rows = 1000)
        response = HTTParty.get(@solr_url, query: params(start, rows))
        json = response.parsed_response
        total = json['response']['numFound']
        results = SolrResults.new(start, total)

        json['response']['docs'].each do |doc|
          results.records.push doc
        end

        results
      end
    end
  end
end
