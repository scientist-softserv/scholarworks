# Generated via
#  `rails generate hyrax:work Publication`
module Hyrax
  class PublicationFormManagers < PublicationForm
    def primary_terms
      %i[resource_type
         title
         alternative_title
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
         extent
         doi
         isbn
         issn
         oclcno
         identifier
         department
         discipline
         keyword
         subject
         language
         related_url
         rights_note
         license
         description_note
         sponsor]
    end
  end
end
