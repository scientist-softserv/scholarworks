# frozen_string_literal: true

module CalState
  module Metadata
    module Solr
      #
      # Solr Query
      #
      class Query
        # @return [Hash] extra solr params
        attr_accessor :extra_params

        #
        # New Solr Query
        #
        # @param campus [String] [optional] campus name
        # @param models [Array] [optional] list of models
        #
        def initialize(campus: nil, models: [])
          @query = limit_to_models(models)
          add limit_to_campus(campus) unless campus.nil?
          @include_suppressed = false
          @extra_params = {}
        end

        #
        # Return the query
        #
        # @return [String]
        #
        def to_query
          add 'suppressed_bsi:false' unless @include_suppressed
          @query
        end

        #
        # Include suppressed records
        #
        def include_suppressed
          @include_suppressed = true
          self
        end

        #
        # Add condition with AND
        #
        # @param statement [String]
        #
        def add(statement)
          @query += " AND #{statement}"
        end

        #
        # Add condition with OR
        #
        # @param statement [String]
        #
        def add_or(statement)
          @query += " OR #{statement}"
        end

        #
        # Works that are open / public
        #
        def limit_to_open_records
          add 'visibility_ssi:open'
          self
        end

        #
        # Works that are not open / public
        #
        def limit_to_restricted_records
          add '-visibility_ssi:open'
          self
        end

        private

        #
        # Limit the query to certain models
        #
        # @param models [Array]  [optional] defaults to all work models
        #
        # @return [String]
        #
        def limit_to_models(models = [])
          models = Metadata.model_names if models.empty?
          "has_model_ssim:(#{models.join(' OR ')})"
        end

        #
        # Limit the query to specified campus
        #
        # @return [String]
        #
        def limit_to_campus(campus)
          "campus_tesim:\"#{campus}\""
        end
      end
    end
  end
end
