module Hyrax 
  module Renderers
    class FacetedForCampusAttributeRenderer < FacetedAttributeRenderer
      def search_path(value)
        campus_search_field = ERB::Util.h(Solrizer.solr_name(options.fetch(:search_field, 'campus'), :facetable, type: :string))
        Rails.application.routes.url_helpers.search_catalog_path(:"f[#{search_field}][]" => value, :"f[#{campus_search_field}]" => options[:campus], locale: I18n.locale)
      end
    end
  end
end
