# Generated via
#  `rails generate hyrax:work Presentation`
#
# Fields to show in Presentation form
#
module Hyrax
  class PresentationForm < Hyrax::CsuForm
    self.model_class = ::Presentation
    self.required_fields += %i[resource_type
                               title
                               creator
                               description]
    def primary_terms
      %i[resource_type
         title
         creator
         description
         date_issued
         place
         meeting_name
         related_url
         department
         discipline
         keyword
         language
         rights_note
         license]
    end
  end
end
