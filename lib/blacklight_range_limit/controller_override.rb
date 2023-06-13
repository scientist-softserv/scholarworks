#
# OVERRIDE class from Blacklight_range_limit v7.0.1
#
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject range limiting behaviors
# to solr parameters creation.
require 'blacklight_range_limit/segment_calculation'
module BlacklightRangeLimit
  module ControllerOverride
    extend ActiveSupport::Concern

    # override range-limit to account for mismatch in range_limit (v.7) vs. blacklight (v.6)
    def range_limit
      @response, _ = search_results(params) do |search_builder|
        search_builder.except(:add_range_limit_params).append(:fetch_specific_range_limit)
      end
      render('blacklight_range_limit/range_segments', :locals => {:solr_field => params[:range_field]}, :layout => !request.xhr?)
    end
  end
end
