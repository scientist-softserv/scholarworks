# frozen_string_literal: true
#
# Inherit from CatalogSearchBuilder to include blacklight advanced search and range limit.
# Builds searches for search result page
#
class Scholars::CatalogSearchBuilder < Hyrax::CatalogSearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::SearchFilters
  self.default_processor_chain += %i[add_advanced_parse_q_to_solr add_advanced_search_to_solr]
end
