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
      solr_document['glacier_location_tesim'].to_a.map do |id|
        parts = id.split("::")
        {date: parts.first, glacier_archive_id: parts.last}
      end
    end
  end
end
