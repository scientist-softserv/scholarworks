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

      #
      # Convert an ActiveFedora relation field into array
      #
      # @param field [ActiveFedora::Base]
      #
      # @return [Array<String>]
      #
      def field_to_array(field)
        final = []
        field.each do |value|
          final << value.to_s
        end
        final
      end
    end
  end
end
