# Generated via
#  `rails generate hyrax:work Presentation`
#
# Fields to show in Presentation form for managers
#
module Hyrax
  class PresentationFormManagers < PresentationForm
    def primary_terms
      %i[resource_type
         title
         alternative_title
         creator
         description
         date_issued
         place
         meeting_name
         related_url
         department
         discipline
         keyword
         subject
         language
         rights_note
         license
         description_note
         extent
         sponsor
         doi
         isbn
         oclcno
         identifier]
    end
  end
end
