#
# Allow a way to search all top level of user collections
#
class CollectionsSearchBuilder < Blacklight::SearchBuilder
  include Hyrax::SearchFilters

  attr_accessor :parent_id, :campus

  self.default_processor_chain += [:filter_by_public, :filter_by_campus, :filter_by_parent_id]

  def initialize(context)
    super(context)
    @parent_id = context.parent_id
    @campus = context.campus
  end

  # adds a filter to the solr_parameters that filters the collections and admin sets
  # the current user has deposited
  # @param [Hash] solr_parameters
  def filter_by_public(solr_parameters)
    solr_parameters[:fq] += [ActiveFedora::SolrQueryBuilder.construct_query(read_access_group_ssim: 'public')]
  end

  # adds a filter to the solr_parameters that filters the collections and admin sets
  # the current user has deposited
  # @param [Hash] solr_parameters
  def filter_by_parent_id(solr_parameters)
    solr_parameters[:fq] += [ActiveFedora::SolrQueryBuilder.construct_query(nesting_collection__parent_ids_ssim: parent_id)] unless parent_id.blank?
  end

  # when searching for campus we only want the top level so parent_id must be blank
  def filter_by_campus(solr_parameters)
    unless campus.blank?
      solr_parameters[:fq] += [ActiveFedora::SolrQueryBuilder.construct_query(campus_tesim: campus)] unless campus.nil?
      solr_parameters[:fq] += [ActiveFedora::SolrQueryBuilder.construct_query(nesting_collection__parent_ids_ssim: '')]
    end
  end
  # Sort results by title if no query was supplied.
  # This overrides the default 'relevance' sort.
  def add_sorting_to_solr(solr_parameters)
    solr_parameters[:sort] ||= "title_ssi asc"
  end

  # This overrides the models in FilterByType and will only filter for user collection (Collection) but not admin collection (AdminSet)
  # @return [Array<Class>] a list of classes to include
  def models
    [::Collection]
  end
end