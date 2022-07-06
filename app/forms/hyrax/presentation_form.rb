# Generated via
#  `rails generate hyrax:work Presentation`
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
         geographical_area
         time_period
         language
         rights_note
         license]
    end
  end
end
