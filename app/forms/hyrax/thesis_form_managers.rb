# Generated via
#  `rails generate hyrax:work Thesis`
#
# Fields to show in Thesis form for managers
#
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
