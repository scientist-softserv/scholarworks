# frozen_string_literal: true
#
# Inherit from blacklight SearchBuilder to build searches for search result page of specific campus
#
class CampusSearchBuilder < Blacklight::SearchBuilder
  include Hydra::AccessControlsEnforcement
  include Hyrax::FilterByType

  attr_accessor :campus, :only_works

  self.default_processor_chain += [:filter_by_campus, :add_sorting_to_solr]

  def initialize(context)
    super(context)
    @campus = context.campus
    @only_works = context.only_works
  end

  def only_works?
    @only_works
  end

  private

  def only_collections?
    !@only_works
  end

  # when searching for campus we only want the top level so parent_id must be blank
  def filter_by_campus(solr_parameters)
    solr_parameters[:fq] += [ActiveFedora::SolrQueryBuilder.construct_query(campus_tesim: campus)] unless campus.blank?
    sort_value = @only_works ? "#{'system_create_dtsi'} desc" : "title_ssi asc"
    solr_parameters[:sort] ||= sort_value
  end

  # Sort results by title if no query was supplied.
  # This overrides the default 'relevance' sort.
  def add_sorting_to_solr(solr_parameters)
    sort_value = @only_works ? "system_create_dtsi desc" : "title_ssi asc"
    solr_parameters[:sort] ||= sort_value
  end
end
