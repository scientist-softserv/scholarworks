# Generated via
#  `rails generate hyrax:work EducationalResource`
#
# Fields to show in EducationResource form
#
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
         creator
         contributor
         description
         date_issued
         department
         discipline
         keyword
         language
         license
         rights_note
         related_url]
    end
  end
end
