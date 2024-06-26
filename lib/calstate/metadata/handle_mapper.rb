# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Shared metadata mapping functions
    #
    class HandleMapper
      include Utilities

      #
      # New HandleMapper
      #
      # @param path [String]  file path to put files
      #
      def initialize(path)
        @path = path
        @solr_reader = Solr::Reader.new
      end

      #
      # Build rewrite mapping files
      #
      def run
        results = @solr_reader.records
        results.each do |doc|
          write_to_file(doc)
        end
      end

      #
      # Write the mapping to the appropriate campus file
      #
      # @param doc [CalState::Metadata::Solr::Record]  solr record
      #
      def write_to_file(doc)
        handle = doc.get('handle').first.to_s
        return if handle.blank?
        return if handle.include?('20.500.12680')

        campus = doc.get('campus').first.to_s
        return if campus.blank?

        campus_filename = campus.underscore.sub(' ', '_')

        File.open(@path + '/' + campus_filename + '.conf', 'a') do |f|
          f.puts get_rewrite_rule(handle, doc.url)
        end
      end

      #
      # Rewrite rule suitable for dspace apache
      #
      # @param handle [String]  full handle url
      # @param url [String]     full url to record in hyrax
      #
      def get_rewrite_rule(handle, url)
        handle = handle.sub('http://hdl.handle.net/', '')
        'RewriteRule ^/handle/' + handle + '$ ' + url
      end
    end
  end
end
