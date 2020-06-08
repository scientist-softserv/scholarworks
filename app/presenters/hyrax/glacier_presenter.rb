module Hyrax
  module GlacierPresenter
    include ModelProxy
    attr_accessor :solr_document

    delegate :glacier_location, to: :solr_document

    # @param [SolrDocument] solr_document
    def initialize(solr_document)
      @solr_document = solr_document
    end

    def glacier_location
      solr_document['glacier_location_tesim']
    end

    def glacier_date
      dates = glacier_location.to_a.map { |gl| Date.parse(gl.split("::").first) }
    end
  end
end
