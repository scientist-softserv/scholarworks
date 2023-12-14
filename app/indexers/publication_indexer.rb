# Generated via
#  `rails generate hyrax:work Publication`
#
# Indexer for Publication work
#
class PublicationIndexer < ::CsuIndexer
  def generate_solr_document
    super
    super.tap do |solr_doc|
      generate_composite_person_fields(solr_doc, object.contributor, 'contributor')
      generate_composite_person_fields(solr_doc, object.editor, 'editor')
    end
  end
end
