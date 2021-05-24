
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

      # add a discipline text search only field
      solr_doc['discipline_search_ids_teim'] = get_discipline_search_ids(solr_doc['discipline_tesim'])
    end
  end

  private

    def get_discipline_search_ids(disciplines)
      discipline_search_ids = ''
      return discipline_search_ids if disciplines.nil? || disciplines.empty?

      disciplines.each do |v|
        discipline_search_ids += ' ' + v + ' ' + DisciplineService::get_ancestor_str(v)
      end
      discipline_search_ids
    end

end
