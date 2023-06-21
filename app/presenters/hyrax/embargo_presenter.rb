#
# OVERRIDE class from Hyrax v2.9.6
# Customization: Presents embargoed objects
#
module Hyrax
  class EmbargoPresenter
    include ModelProxy
    attr_accessor :solr_document

    delegate :human_readable_type, :visibility, :campus, :to_s, to: :solr_document

    # @param [SolrDocument] solr_document
    def initialize(solr_document)
      @solr_document = solr_document
    end

    def embargo_release_date
      solr_document.embargo_release_date.to_formatted_s(:rfc822)
    end

    def visibility_after_embargo
      solr_document.fetch('visibility_after_embargo_ssim', []).first
    end

    def embargo_history
      solr_document['embargo_history_ssim']
    end

    def campus
      solr_document.fetch('campus_tesim', []).first
    end
  end
end
