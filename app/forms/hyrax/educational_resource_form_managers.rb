# Generated via
#  `rails generate hyrax:work EducationalResource`
module Hyrax
  # Generated form for EducationalResource
  class EducationalResourceForm < Hyrax::CsuForm
    self.model_class = ::EducationalResource
    self.required_fields += %i[resource_type
                               title
                               creator
                               description]
    def primary_terms
      %i[resource_type
         title
         alternative_title
         creator
         contributor
         description
         date_issued
         department
         discipline
         keyword
         subject
         language
         license
         rights_note
         related_url
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
