
class CsuIndexer < Hyrax::WorkIndexer
  # This indexes the default metadata. You can remove it if you want to
  # provide your own metadata and indexing.
  include Hyrax::IndexesBasicMetadata

  # Fetch remote labels for based_near. You can remove this if you don't want
  # this behavior
  include Hyrax::IndexesLinkedMetadata

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc['handle_suffix_sim'] = object.handle_suffix

      # add a discipline text search only field and person sim
      generate_discipline_search_ids(solr_doc, solr_doc['discipline_tesim'])
      generate_name(solr_doc, object.creator, 'creator')
    end
  end

  protected

  def generate_name(solr_doc, person, person_type)
    names = []
    person.each do |p|
      person = Person.new.from_hyrax(p)
      names << person.name
    end
    solr_doc[person_type + '_name_sim'] = names
  end

  private

  def generate_discipline_search_ids(solr_doc, disciplines)
    discipline_search_ids = ''
    return discipline_search_ids if disciplines.nil? || disciplines.empty?

    disciplines.each do |v|
      discipline_search_ids += ' ' + v + ' ' + DisciplineService::get_ancestor_str(v)
    end
    solr_doc['discipline_search_ids_teim'] = discipline_search_ids
  end
end
