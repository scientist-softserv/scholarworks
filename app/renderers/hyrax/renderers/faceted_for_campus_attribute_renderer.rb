#
# Special rendering to display URL for campus facet
#
module Hyrax
  module Renderers
    class FacetedForCampusAttributeRenderer < FacetedAttributeRenderer
      def search_path(value)
        campus_search_field = ERB::Util.h('campus_sim')
        Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value, :"f[#{campus_search_field}]" => options[:campus], locale: I18n.locale)
      end
    end
  end
end
