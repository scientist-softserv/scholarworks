#
# OVERRIDE class from hyrax v3.6.0
# Customization: Return up to 99 collections, sorted by collection title
#
class Hyrax::HomepageController < ApplicationController
  # Adds Hydra behaviors into the application controller
  include Blacklight::SearchContext
  include Blacklight::SearchHelper
  include Blacklight::AccessControls::Catalog
  include ActionView::Helpers::NumberHelper

  # The search builder for finding recent documents
  # Override of Blacklight::RequestBuilders
  def search_builder_class
    Hyrax::HomepageSearchBuilder
  end

  class_attribute :presenter_class
  self.presenter_class = Hyrax::HomepagePresenter
  layout 'homepage'
  helper Hyrax::ContentBlockHelper

  def index
    @presenter = presenter_class.new(current_ability, collections)
    @featured_researcher = ContentBlock.for(:researcher)
    @marketing_text = ContentBlock.for(:marketing)
    @announcement_text = ContentBlock.for(:announcement)
    recent
  end

  private

  # Return 5 collections
  def collections(rows: 5)
    builder = Hyrax::CollectionSearchBuilder.new(self)
                                            .rows(rows)
    response = repository.search(builder)
    response.documents
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    []
  end

  def recent
    # grab any recent documents
    (@solr_response, @recent_documents) = search_results(q: '', sort: sort_field, rows: 10)
    # total number of documents
    @total = (@recent_documents.first) ? @recent_documents.first.response.response["numFound"] : 0
    @total = number_with_delimiter(@total)
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    @solr_response = []
    @recent_documents = []
    @total = 0
  end

  def sort_field
    "#{'system_create_dtsi'} desc"
  end
end
