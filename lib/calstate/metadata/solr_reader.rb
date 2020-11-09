# frozen_string_literal: true

require 'httparty'

module CalState
  module Metadata
    #
    # Fast Solr read-only queries for all metadata records
    #
    class SolrReader
      include Utilities

      # @return [Boolean]  whether to include suppressed records
      attr_accessor :include_suppressed

      #
      # New SolrReader
      #
      def initialize
        @solr_url = ENV['SOLR_URL'] + '/select'
      end

      #
      # Fetch all records
      #
      # @return [Array] of solr documents
      #
      def fetch_all
        solr_query = query(true)
        fetch_records(solr_query)
      end

      #
      # Fetch all unsuppressed records
      #
      # @return [Array] of solr documents
      #
      def fetch_all_unsuppressed
        solr_query = query(false)
        fetch_records(solr_query)
      end

      #
      # Find duplicate records
      #
      # @param [String] field  [optional] the solr field key
      #
      def find_duplicates(field = 'handle_tesim')
        handles = {}
        dupes = {}

        fetch_all.each do |doc|
          handle = doc[field].first.to_s
          if handles[handle]
            handles[handle].append(doc['id'])
          else
            handles[handle] = [doc['id']]
          end
        end

        handles.each do |key, ids|
          dupes[key] = ids if ids.length > 1
        end

        dupes
      end

      private

      #
      # Fetch metadata records from the repository
      #
      # @param [String] solr_query  solr query
      #
      # @return [Array] of solr documents
      #
      def fetch_records(solr_query)
        start = 0
        results = []

        loop do
          results_batch = fetch_batch(solr_query, start, 1000)
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
      # @param [String] query   solr query
      # @param [Integer] start  [optional] starting record number
      # @param [Integer] rows   [optional] number of rows to fetch
      #
      # @return [SolrResults]
      #
      def fetch_batch(query, start = 0, rows = 1000)
        response = HTTParty.get(@solr_url, query: params(query, start, rows))
        json = response.parsed_response
        total = json['response']['numFound']
        results = SolrResults.new(start, total)

        json['response']['docs'].each do |doc|
          results.records.push doc
        end

        results
      end

      #
      # Solr query to retrieve all open, unsuppressed records
      #
      # @param [Boolean] include_suppressed  [optional] include suppressed records?
      #
      # @return [String] Solr query
      #
      def query(include_suppressed = false)
        models_query = []
        Metadata.model_names.each do |model|
          models_query.push 'has_model_ssim:' + model
        end

        query = models_query.join(' OR ')

        if include_suppressed == false
          "(#{query}) AND suppressed_bsi:false AND visibility_ssi:open"
        else
          query
        end
      end

      #
      # Solr parameters for paging
      #
      # @param [String] query   solr query
      # @param [Integer] start  starting record position (default: 0)
      # @param [Integer] rows   number of rows to return (default: 1,000)
      #
      # @return [Hash] parameters, with query and wt: json
      #
      def params(query, start = 0, rows = 1000)
        {
          q: query,
          start: start,
          rows: rows,
          wt: 'json'
        }
      end
    end
  end
end
