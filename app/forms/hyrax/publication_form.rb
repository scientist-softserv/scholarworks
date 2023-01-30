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
         publication_title
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
         language
         related_url
         rights_note
         license]
    end
  end
end
