# frozen_string_literal: true

module CalState
  module Metadata
    module Solr
      #
      # Solr record (read-only)
      #
      class Record
        #
        # Solr Record
        #
        # @param json [JSON]  Solr JSON document
        #
        def initialize(json)
          @doc = convert(json)
        end

        #
        # Get value
        #
        # @param field [String]  field name
        # @param default         [optional] default value
        #
        # return empty value if field not present in Solr document
        #
        def get(field, default = nil)
          if @doc.include?(field)
            @doc[field]
          elsif !default.nil?
            default
          elsif FieldService.single_fields.include?(field)
            ""
          else
            []
          end
        end

        #
        # Get full URL to this record
        #
        # @return [String] full URL
        #
        def url
          model_path = @doc['has_model'].first.underscore.pluralize
          'https://' + ENV['SCHOLARWORKS_HOST'] + '/concern/' + model_path + '/' + @doc['id']
        end

        private

        #
        # Convert Solr hash keys to field names without suffix
        #
        # @param doc [JSON]  Solr document
        #
        # @return [Hash]
        #
        def convert(doc)
          final = {}

          doc.each do |field, value|
            attr = if field.include?('_')
                     parts = field.split('_')
                     parts.pop
                     parts.join('_')
                   else
                     field
                   end
            final[attr] = value
          end

          final
        end
      end
    end
  end
end
