class CampusController < ApplicationController
  include Blacklight::SearchContext
  include Blacklight::SearchHelper
  include Blacklight::AccessControls::Catalog

  attr_accessor :campus, :only_works

  # The search builder for finding recent documents
  # Override of Blacklight::RequestBuilders
  def search_builder_class
    CampusSearchBuilder
  end

  # Returned all public collections for a particular campus and to the homepage when campus name is invalid
  def index
    @campus = CampusService.get_name_from_slug(params[:campus])
    params['f[campus_sim][]'] = @campus
    params.delete(:campus)
    @featured_work_list = FeaturedWorkList.new(@campus)
    @collections = collections
    works
  end

  private

  # Return collections for this campus and sort by title
  def collections
    @only_works = false
    (@response, @documents) = search_results(params)
    items = []
    @documents.each do |doc|
      items << SimpleCollection.new(doc.id, doc.title.join(''))
    end
    items
  end

  # return works for this campus and sort by date created
  def works
    @only_works = true
    (@response, @recent_documents) = search_results(q: '', rows: 5)
  rescue Blacklight::Exceptions::ECONNREFUSED, Blacklight::Exceptions::InvalidRequest
    @recent_documents = []
  end
end
