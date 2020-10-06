# frozen_string_literal: true

require 'nokogiri'

module CalState
  module Metadata
    #
    # Sitemap builder
    #
    class Sitemap
      include Utilities
      #
      # New Sitemap
      #
      # @param [String] path  path to location of sitemap files
      #
      def initialize(path)
        @path = path
        @solr_reader = SolrReader.new
      end

      #
      # Build sitemap
      #
      def run
        results = @solr_reader.fetch_all_unsuppressed

        # we'll chunk the results into smaller groups to ensure our sitemap
        # files are not too large: < 5MB
        batches = results.each_slice(20_000).to_a
        sitemap_files = write_sitemap_files(batches)
        write_master_sitemap_file(sitemap_files)
      end

      #
      # Write out batches of sitemap files
      #
      # @param [Array] batches  groups of Solr docs
      #
      # @return [Array] list of sitemap files
      #
      def write_sitemap_files(batches)
        files = []
        x = 1

        batches.each do |batch|
          builder = Nokogiri::XML::Builder.new do |xml|
            xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
              batch.each do |doc|
                xml.url {
                  xml.loc get_url(doc)
                  xml.lastmod doc['system_modified_dtsi']
                  xml.changefreq 'monthly'
                }
              end
            }
          end
          file_name = @path + '/sitemap-' + x.to_s + '.xml'
          files.append file_name
          File.write(file_name, builder.to_xml)
          x += 1
        end

        files
      end

      #
      # Write out master sitemap file
      #
      # @param [Array] files  list of sitemap files
      #
      def write_master_sitemap_file(files)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.urlset('xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9') {
            xml.sitemapindex
            files.each do |site_map_file|
              xml.sitemap {
                xml.loc hyrax_url + '/' + site_map_file
                xml.lastmod Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
              }
            end
          }
        end
        File.write(@path + '/sitemap.xml', builder.to_xml)
      end
    end
  end
end
