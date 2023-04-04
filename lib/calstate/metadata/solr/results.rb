# frozen_string_literal: true

module CalState
  module Metadata
    module Solr
      #
      # Solr results
      #
      class Results
        # @return [Integer] starting record number
        attr_reader :start

        # @return [Integer] number of records
        attr_reader :total

        # @return [Array<JSON>] solr documents
        attr_reader :records

        # @return [Hash] facets
        attr_reader :facet_fields

        # @return [Hash<Array>] pivot facets
        attr_reader :facet_pivot

        #
        # New Solr Results
        #
        # @param json [JSON]  Solr JSON response
        #
        def initialize(json)
          @start = json['response']['start']
          @total = json['response']['numFound']
          @records = extract_docs(json)
          @facet_fields = extract_facet_fields(json)
          @facet_pivot = json['facet_counts']['facet_pivot']
        end

        #
        # The next record number to fetch
        #
        # @return [Integer]
        #
        def pointer
          @start + @records.length
        end

        private

        #
        # Extract the docs
        #
        # @param json [JSON]
        #
        # @return [Array]
        #
        def extract_docs(json)
          records = []
          json['response']['docs'].each do |doc|
            records.push doc
          end

          records
        end

        #
        # Extract facet fields
        #
        # @param json [JSON]
        #
        # @return [Hash]
        #
        def extract_facet_fields(json)
          facets = {}
          json['facet_counts']['facet_fields'].each do |field, values|
            facets[field] = {}
            x = 0
            field_name = String.new
            values.each do |value|
              x += 1
              if x.odd?
                field_name = value
              else
                facets[field][field_name] = value
              end
            end
          end

          facets
        end
      end
    end
  end
end
