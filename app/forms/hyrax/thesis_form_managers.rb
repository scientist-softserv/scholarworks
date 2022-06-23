# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisFormManagers < ThesisForm
    def primary_terms
      %i[resource_type
         title
         alternative_title
         creator
         description
         date_issued
         degree_name
         degree_program
         advisor
         committee_member
         department
         discipline
         keyword
         subject
         geographical_area
         time_period
         language
         license
         rights_note
         description_note
         extent
         sponsor
         related_url
         doi
         isbn
         oclcno
         identifier]
    end
  end
end
