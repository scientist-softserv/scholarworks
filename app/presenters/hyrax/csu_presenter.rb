
module Hyrax
  #
  # Shared presenter for CSU fields
  #
  class CsuPresenter < Hyrax::WorkShowPresenter
    # csu metadata
    delegate :abstract,
             :alternative_title,
             :bibliographic_citation,
             :campus,
             :college,
             :date_accessioned,
             :date_available,
             :date_copyright,
             :date_issued,
             :date_issued_year,
             :date_submitted,
             :department,
             :description_note,
             :discipline,
             :doi,
             :embargo_terms,
             :extent,
             :geographical_area,
             :handle,
             :identifier_uri,
             :issn,
             :isbn,
             :is_part_of,
             :license,
             :oclcno,
             :provenance,
             :rights_holder,
             :rights_note,
             :rights_uri,
             :sponsor,
             :statement_of_responsibility,
             :time_period, to: :solr_document

    # dataset
    delegate :investigator, to: :solr_document

    # publication
    delegate :editor,
             :publication_status, to: :solr_document

    # thesis
    delegate :advisor,
             :committee_member,
             :degree_level,
             :degree_name,
             :granting_institution, to: :solr_document
  end
end
