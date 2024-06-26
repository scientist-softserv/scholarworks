#
# OVERRIDE class from blacklight_advanced_search v6.4.1
#
module BlacklightAdvancedSearch::CatalogHelperOverride
  # Special display for facet limits that include adv search inclusive
  # or limits.
  def facet_partial_name(display_facet = nil)
    return "blacklight_advanced_search/facet_limit" if advanced_query && advanced_query.filters.keys.include?(display_facet.name)
    super
  end

  def remove_advanced_facet_param(field, value, my_params = params)
    my_params = Blacklight::SearchState.new(my_params, blacklight_config).to_h



    ### CUSTOMIZATION:
    # just override this so it doesn't complain about no route error in the
    # front end as it generates the remote facet link as it sets to 'advanced'

    my_params['controller'] = 'catalog'

    ### END CUSTOMIZATION
    


    if (my_params[:f_inclusive] &&
        my_params[:f_inclusive][field] &&
        my_params[:f_inclusive][field].include?(value))

      my_params[:f_inclusive] = my_params[:f_inclusive].dup
      my_params[:f_inclusive][field] = my_params[:f_inclusive][field].dup
      my_params[:f_inclusive][field].delete(value)

      my_params[:f_inclusive].delete(field) if my_params[:f_inclusive][field].empty?

      my_params.delete(:f_inclusive) if my_params[:f_inclusive].empty?
    end

    my_params.delete_if do |key, _value|
      [:page, :id, :counter, :commit].include?(key)
    end

    my_params
  end
end
