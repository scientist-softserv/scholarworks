# Generated via
#  `rails generate hyrax:work Thesis`
#
# Indexer for Thesis work
#
class ThesisIndexer < ::CsuIndexer
  def generate_solr_document
    super
    super.tap do |solr_doc|
      generate_composite_person_fields(solr_doc, object.advisor, 'advisor')
      generate_composite_person_fields(solr_doc, object.committee_member, 'committee_member')
    end
  end
end
