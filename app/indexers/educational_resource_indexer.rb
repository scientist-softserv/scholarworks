# Generated via
#  `rails generate hyrax:work EducationalResource`
#
# Indexer for EducationResource work
#
class EducationalResourceIndexer < ::CsuIndexer
  def generate_solr_document
    super
    super.tap do |solr_doc|
      generate_composite_person_fields(solr_doc, object.contributor, 'contributor')
    end
  end
end
