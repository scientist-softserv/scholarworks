# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationForm < Hyrax::CsuForm
    self.model_class = ::Publication
    self.required_fields += %i[resource_type
                               title
                               description
                               date_issued]
    def primary_terms
      %i[resource_type
         title
         creator
         contributor
         description
         date_issued
         edition
         editor
         publisher
         place
         series
         is_part_of
         volume
         issue
         pages
         doi
         isbn
         issn
         identifier
         department
         discipline
         keyword
         geographical_area
         time_period
         language
         related_url
         rights_note
         license]
    end
  end
end
