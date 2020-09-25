# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

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
      # @param [String] hyrax_url  url of the Hyrax instance
      # @param [String] solr_url   url to solr server, with path to core
      # @param [Hash] mapping      url slug to model mapping
      #
      def initialize(hyrax_url, solr_url)
        @hyrax_url = hyrax_url
        @solr_url = solr_url + '/select'
        @mapping = url_mapping
      end

      #
      # Solr query to retrieve all open, un-supressed records
      #
      # @return [String] Solr query
      #
      def query
        models = []
        @mapping.each do |_, model|
          models.push 'has_model_ssim:' + model
        end
        query = '(' + models.join(' OR ') + ') '
        query += 'AND suppressed_bsi:false AND visibility_ssi:open'
        query
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
      # Build a (Google) sitemap
      #
      # @param [String] file_path  path to file
      #
      # @return [Integer] size of file
      #
      def build_sitemap(file_path)
        results = fetch_all
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
            results.each do |doc|
              xml.url {
                xml.loc get_url(doc)
                xml.lastmod doc['system_modified_dtsi']
                xml.changefreq 'yearly'
              }
            end
          }
        end
        File.write(file_path, builder.to_xml)
      end

      #
      # Fetch all metadata records from the repository
      #
      # @param [Integer] rows  [optional] number of records per batch (default: 1,000)
      #
      # @return [Array<JSON>] of JSON document
      #
      def fetch_all(rows = 1000)
        start = 0
        total = 0
        results = []

        loop do
          response = HTTParty.get(@solr_url, query: params(start, rows))
          json = response.parsed_response
          total = json['response']['numFound']

          json['response']['docs'].each do |doc|
            start += 1
            results.push doc
          end

          break if total <= start
        end

        results
      end

      #
      # Construct full URL to the metadata record
      #
      # @param [JSON] doc  metadata record
      #
      # @return [String] full URL
      #
      def get_url(doc)
        type = @mapping.key(doc['has_model_ssim'].first).to_s
        @hyrax_url + '/concern/' + type + '/' + doc['id']
      end
    end
  end
end
