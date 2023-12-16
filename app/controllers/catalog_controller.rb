# frozen_string_literal: true
#
# OVERRIDE class from Blacklight v6.25.0
# Customization: To support blacklight advanced search and date range.
#
class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include BlacklightRangeLimit::ControllerOverride
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior
  include BlacklightOaiProvider::Controller

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  def self.uploaded_field
    solr_name('system_create', :stored_sortable, type: :date)
  end

  def self.modified_field
    solr_name('system_modified', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'dismax'
    config.advanced_search[:form_solr_parameters] ||= {}

    # so super long queries don't cause http 414 errors
    config.http_method = :post

    config.view.gallery.partials = %i[index_header index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = Scholars::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = %i[index_header index]
    config.view.slideshow.partials = [:index]

    # solr field configuration for document/show views
    config.index.title_field = 'title_tesim'
    config.index.display_type_field = 'has_model_ssim'
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # facets

    SystemService.facets.each do |field, attr|
      solr_field = "#{field}_sim"
      attr[:label] = 'blacklight.search.fields.facet.' + solr_field
      config.add_facet_field(solr_field, attr)
    end

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field 'generic_type_sim', if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # fields to search

    FieldService.show_fields.each do |field|
      config.add_show_field "#{field}_tesim"
    end

    config.add_search_field('all_fields', label: 'All Fields') do |field|
      all_names = config.show_fields.values.map(&:field).join(' ')
      field.solr_parameters = {
        qt: 'search',
        rows: 10,
        qf: "#{all_names} file_format_tesim all_text_timv handle_sim id",
        pf: 'title_tesim'
      }
    end

    # advanced search fields

    SystemService.advanced_search.each do |solr_field|
      config.add_search_field(solr_field) do |field|
        solr_name = "#{solr_field}_tesim"
        field.solr_local_parameters = {
          qf: solr_name,
          pf: solr_name
        }
      end
    end

    # sort options

    config.add_sort_field "score desc, #{uploaded_field} desc", label: 'relevance'
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    config.oai = {
      provider: {
        repository_url: 'http://' + ENV.fetch('SCHOLARWORKS_HOST', 'localhost:3000') + '/catalog/oai',
        repository_name: I18n.t('hyrax.product_name'),
        record_prefix: I18n.t('hyrax.oai_record_prefix'),
        admin_email: 'library@calstate.edu',
        sample_id: '101010'
      },
      document: {
        limit: 25, # number of records returned with each request, default: 15
        set_fields: [ # ability to define ListSets, optional, default: nil
          { label: 'campus', solr_field: 'campus_sim' }
        ]
      }
    }

    # End configure_blacklight
  end

  # disable the bookmark control from displaying in gallery view
  # Hyrax doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end
end
