# frozen_string_literal: true

require 'httparty'

module CalState
  module Metadata
    module Solr
      #
      # Fast Solr read-only queries for all metadata records
      #
      class Reader
        include Utilities
        include HTTParty
        disable_rails_query_string_format

        # @return [Query] solr query
        attr_accessor :query

        #
        # New Solr Reader
        #
        # @param campus [String] [optional] campus name
        # @param models [Array] [optional] list of models
        #
        def initialize(campus: nil, models: [])
          @solr_url = "#{ENV['SOLR_URL']}/select"
          @query = Query.new(campus: campus, models: models)
        end

        #
        # All (including suppressed) works
        #
        # @return [Array] of solr documents
        #
        def records
          @query.include_suppressed
          fetch_all(@query)
        end

        #
        # All unsuppressed works
        #
        # @return [Array] of solr documents
        #
        def public_records
          @query.limit_to_open_records
          fetch_all(@query)
        end

        #
        # Works that have private visibility
        #
        # @return [Array] of solr documents
        #
        def restricted_records
          @query.limit_to_restricted_records
          fetch_all(@query)
        end

        #
        # Works that have an expired embargo
        #
        # @return [Array] of solr documents
        #
        def records_with_expired_embargoes
          @query.add 'embargo_release_date_dtsi:[* TO NOW]'
          fetch_all(@query)
        end

        #
        # Get all values for a facet
        #
        # @param fields [Array]   solr field name(s)
        # @param limit [Integer]  [optional] number of values to return
        #
        # @return [Hash<Array>]
        #
        def fetch_facets(fields, limit = 1000)
          @query.all_records
          @query.extra_params = {
            facet: true,
            'facet.field': fields,
            'facet.limit': limit
          }

          results = fetch(@query, 0, 0)

          # extract just the values
          values = {}
          fields.each do |field|
            values[field] = []
            x = 0
            results.facets['facet_fields'][field].each do |value|
              x += 1
              values[field].append(value) if x.odd?
            end
          end

          values
        end

        #
        # Fetch all records
        #
        # @param query [Query]  solr query
        #
        # @return [Array] of solr documents
        #
        def fetch_all(query)
          start = 0
          results = []

          loop do
            results_batch = fetch(query, start, 1000)
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
        # @param query [Query]    solr query
        # @param start [Integer]  [optional] starting record number
        # @param rows [Integer]   [optional] number of rows to fetch, default 1,000
        #
        # @return [Results]
        #
        def fetch(query, start = 0, rows = 1000)
          json = get(query, start, rows)
          Results.new(json)
        end

        private

        #
        # Fetch response from Solr
        #
        # @param query [Query]        solr query
        # @param start [Integer]      [optional] starting record number
        # @param rows [Integer]       [optional] number of rows to fetch
        #
        # @return [JSON]
        #
        def get(query, start = 0, rows = 0)
          params = {
            fq: query.to_query,
            start: start,
            rows: rows,
            wt: 'json'
          }
          params.merge!(query.extra_params)
          response = self.class.get(@solr_url, query: params)

          response.parsed_response
        end
      end
    end
  end
end
