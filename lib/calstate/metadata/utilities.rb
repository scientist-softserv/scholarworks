# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Shared metadata mapping functions
    #
    module Utilities
      #
      # Base url for Hyrax
      #
      # @return [String]
      #
      def hyrax_url
        'https://' + ENV['SCHOLARWORKS_HOST']
      end

      #
      # Construct full URL to a record
      #
      # @param doc [JSON]  solr record
      #
      # @return [String] full URL
      #
      def get_url(doc)
        model_path = doc['has_model_ssim'].first.underscore.pluralize
        hyrax_url + '/concern/' + model_path + '/' + doc['id']
      end
    end
  end
end
