#
# OVERRIDE class from blacklight_range_limit v7.0.1
#
# Meant to be applied on top of a controller that implements
# Blacklight::SolrHelper. Will inject range limiting behaviors
# to solr parameters creation.
require 'blacklight_range_limit/segment_calculation'
module BlacklightRangeLimit
  module ControllerOverride
    extend ActiveSupport::Concern



    ### CUSTOMIZATION: remove includes to avoid MultipleIncludedBlocks errors

    # included do
    #  helper BlacklightRangeLimit::ViewHelperOverride
    #  helper RangeLimitHelper
    # end

    ### END CUSTOMIZATION



    # Action method of our own!
    # Delivers a _partial_ that's a display of a single fields range facets.
    # Used when we need a second Solr query to get range facets, after the
    # first found min/max from result set.
    def range_limit
      # We need to swap out the add_range_limit_params search param filter,
      # and instead add in our fetch_specific_range_limit filter,
      # to fetch only the range limit segments for only specific
      # field (with start/end params) mentioned in query params
      # range_field, range_start, and range_end



        ### CUSTOMIZATION:
        # override range-limit to account for mismatch in range_limit (v.7) vs. blacklight (v.6)

        @response, _ = search_results(params) do |search_builder|

        ### END CUSTOMIZATION



        search_builder.except(:add_range_limit_params).append(:fetch_specific_range_limit)
      end
      render('blacklight_range_limit/range_segments', :locals => {:solr_field => params[:range_field]}, :layout => !request.xhr?)
    end
  end
end
