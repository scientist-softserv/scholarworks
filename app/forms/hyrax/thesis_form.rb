# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::Forms::WorkForm
    self.model_class = ::Thesis
    self.terms += [:resource_type_thesis, :date_submitted, :handle, :college,
      :department, :degree_level, :degree_name, :advisor, :committee_member,
      :date_issued, :alternative_title, :subject, :extent, :publisher, :time_period,
      :geographical_area, :date_copyright, :date_available, :identifier, :granting_institution,
      :rights_note, :rights_uri, :rights_holder, :doi, :oclcno, :issn, :isbn, :identifier_uri,
      :bibliographic_citation, :description_note, :sponsor]

    self.terms -= [:contributor, :license, :publisher, :date_created, :date_available,
                   :date_copyright, :date_submitted,
                   :location, :related_url, :source, :handle, :based_near, :keyword, :extent,
                   :sponsor, :license]

    self.required_fields += [:creator, :title, :description, :resource_type_thesis]

    self.required_fields -= [:rights_statement, :keyword, :alternative_title, :date_issued]

    def primary_terms
      [:creator, :title, :description, :resource_type_thesis, :rights_statement]
    end

    def secondary_terms
      [:alternative_title, :advisor, :committee_member, :publisher, :college, :department, :degree_level, :degree_name,
       :date_issued, :subject, :language, :rights_holder, :rights_uri, :rights_note,
       :time_period, :geographical_area, :doi, :isbn, :issn, :oclcno, :identifier, :identifier_uri,
       :granting_institution, :bibliographic_citation, :description_note]
    end
  end
end
