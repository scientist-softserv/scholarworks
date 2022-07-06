# frozen_string_literal: true

require 'httparty'

module CalState
  module Metadata
    #
    # Fast Solr read-only queries for all metadata records
    #
    class SolrReader
      include Utilities
      include HTTParty
      disable_rails_query_string_format

      #
      # New SolrReader
      #
      def initialize
        @solr_url = ENV['SOLR_URL'] + '/select'
      end

      #
      # All (including suppressed) works
      #
      # @return [Array] of solr documents
      #
      def records
        solr_query = query_all_records(true)
        fetch_records(solr_query)
      end

      #
      # All unsuppressed works
      #
      # @return [Array] of solr documents
      #
      def public_records
        solr_query = query_all_records(false)
        fetch_records(solr_query)
      end

      #
      # Works that have private visibility
      #
      # @return [Array] of solr documents
      #
      def restricted_records(campus = nil)
        query = limit_to_models +
                ' AND -visibility_ssi:open AND suppressed_bsi:false'
        query += ' AND ' + limit_to_campus(campus) unless campus.nil?
        query += ' AND timestamp:[2022-02-08T00:00:00Z TO NOW]'
        fetch_records(query)
      end

      #
      # Works that have an expired embargo
      #
      # @return [Array] of solr documents
      #
      def records_with_expired_embargoes
        query = 'embargo_release_date_dtsi:[* TO NOW]'
        fetch_records(query)
      end

      #
      # Get all facet values
      #
      # @param fields [Array]   solr field name(s)
      # @param campus [String]  [optional] campus name
      # @param models [Array]   [optional] models to search, default is works
      # @param limit [Integer]  [optional] number of values to return
      #
      # @return [Array]
      #
      def facet_values(fields, campus = nil, models = [], limit = 1000)
        query = if models.empty?
                  query_all_records
                else
                  limit_to_models(models) + ' AND ' + limit_to_open_records
                end
        query += ' AND ' + limit_to_campus(campus) unless campus.nil?
        params = {
          facet: true,
          'facet.field': fields,
          'facet.limit': limit
        }
        json = fetch(query, 0, 0, params)

        # extract values
        values = {}
        fields.each do |field|
          values[field] = []
          x = 0
          json['facet_counts']['facet_fields'][field].each do |value|
            x += 1
            values[field].append(value) if x.odd?
          end
        end

        values
      end

      private

      #
      # Fetch metadata records from the repository
      #
      # @param solr_query [String]  solr query
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
      # @param query [String]   solr query
      # @param start [Integer]  [optional] starting record number
      # @param rows [Integer]   [optional] number of rows to fetch
      #
      # @return [SolrResults]
      #
      def fetch_batch(query, start = 0, rows = 1000)
        json = fetch(query, start, rows)
        total = json['response']['numFound']
        results = SolrResults.new(start, total)

        json['response']['docs'].each do |doc|
          results.records.push doc
        end

        results
      end

      #
      # Fetch response from Solr
      #
      # @param query [String]       solr query
      # @param start [Integer]      [optional] starting record number
      # @param rows [Integer]       [optional] number of rows to fetch
      # @param extra_params [hash]  [optional] extra parameters
      #
      # @return [JSON]
      #
      def fetch(query, start = 0, rows = 0, extra_params = {})
        params = {
          fq: query,
          start: start,
          rows: rows,
          wt: 'json'
        }
        params.merge!(extra_params)
        response = self.class.get(@solr_url, query: params)
        response.parsed_response
      end

      #
      # Query to retrieve all works
      #
      # @param include_suppressed [Boolean]  [optional] include suppressed records?
      #
      # @return [String] Solr query
      #
      def query_all_records(include_suppressed = false)
        query = limit_to_models
        query + ' AND ' + limit_to_open_records unless include_suppressed
        query
      end

      #
      # Limit the query to public records
      #
      # @return [String]
      #
      def limit_to_open_records
        'suppressed_bsi:false AND visibility_ssi:open'
      end

      #
      # Limit the query to certain models
      #
      # @param models [Array]  [optional] defaults to all work models
      #
      # @return [String]
      #
      def limit_to_models(models = [])
        models = Metadata.model_names if models.empty?
        'has_model_ssim:(' + models.join(' OR ') + ')'
      end

      #
      # Limit the query to specified campus
      #
      # @return [String]
      #
      def limit_to_campus(campus)
        'campus_tesim:"' + campus + '"'
      end
    end
  end
end
