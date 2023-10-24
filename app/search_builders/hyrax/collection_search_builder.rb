# frozen_string_literal: true
module Hyrax
  # Our parent class is the generated SearchBuilder descending from Blacklight::SearchBuilder
  # It includes Blacklight::Solr::SearchBuilderBehavior, Hydra::AccessControlsEnforcement, Hyrax::SearchFilters
  # @see https://github.com/projectblacklight/blacklight/blob/master/lib/blacklight/search_builder.rb Blacklight::SearchBuilder parent
  # @see https://github.com/projectblacklight/blacklight/blob/master/lib/blacklight/solr/search_builder_behavior.rb Blacklight::Solr::SearchBuilderBehavior
  # @see https://github.com/samvera/hyrax/blob/master/app/search_builders/hyrax/README.md SearchBuilders README
  # @note the default_processor_chain defined by Blacklight::Solr::SearchBuilderBehavior provides many possible points of override
  #
  # Allows :deposit as a valid type
  #
  # OVERRIDE class from Hyrax v3.6.0
  # Customization: Change action according to Hyrax original commit
  #
  class CollectionSearchBuilder < ::SearchBuilder
    include FilterByType

    attr_reader :access

    # Overrides Hydra::AccessControlsEnforcement
    def discovery_permissions
      @discovery_permissions = extract_discovery_permissions(@access)
    end

    # @return [String] Solr field name indicating default sort order
    #       x
    #       # Set file's campus from work's campus
    #
    #       actor.file_set.campus = work.campus
    #
    #       ### END CUSTOMIZATION
    def sort_field
      ### CUSTOMIZATION
      # Used to be title_si, not sure why title_ssi would sort title asc for collection

      "title_ssi"

      ### END CUSTOMIZATION
    end

    # This overrides the models in FilterByType
    def models
      collection_classes
    end

    def with_access(access)
      @access = access
      super(access)
    end

    # Sort results by title if no query was supplied.
    # This overrides the default 'relevance' sort.
    def add_sorting_to_solr(solr_parameters)
      return if solr_parameters[:q]
      solr_parameters[:sort] ||= "#{sort_field} asc"
    end

    # If :deposit access is requested, check to see which collections the user has
    # deposit or manage access to.
    # @return [Array<String>] a list of filters to apply to the solr query
    def gated_discovery_filters(permission_types = discovery_permissions, ability = current_ability)
      return super unless permission_types.include?("deposit")
      ["{!terms f=id}#{collection_ids_for_deposit.join(',')}"]
    end

    private

    def collection_ids_for_deposit
      Hyrax::Collections::PermissionsService.collection_ids_for_deposit(ability: current_ability)
    end

    ACCESS_LEVELS_FOR_LEVEL = ActiveSupport::HashWithIndifferentAccess.new(
      edit: ["edit"],
      deposit: ["deposit"],
      read: ["edit", "read"]
    ).freeze
    def extract_discovery_permissions(access)
      access = :read if access.blank?
      ACCESS_LEVELS_FOR_LEVEL.fetch(access)
    end
  end
end
