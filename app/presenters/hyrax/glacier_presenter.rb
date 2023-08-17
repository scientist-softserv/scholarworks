#
# Refactor from file_set_presenter so we don't need to import this whole file just to include it
#
module Hyrax
  module GlacierPresenter
    include ModelProxy
    attr_accessor :solr_document

    delegate :glacier_location, to: :solr_document

    # @param [SolrDocument] solr_document
    def initialize(solr_document)
      @solr_document = solr_document
    end

    def glacier_locations
      solr_document['glacier_location_tesim'].to_a.map do |key|
        parts = key.split("/")
        {human_readable: parts.last, s3_key: key}
      end
    end
  end
end
