# Generated via
#  `rails generate hyrax:work Publication`
class PublicationIndexer < ::CsuIndexer
  def generate_solr_document
    super
    super.tap do |solr_doc|
      generate_name(solr_doc, object.contributor, 'contributor')
      generate_name(solr_doc, object.editor, 'editor')
    end
  end
end
