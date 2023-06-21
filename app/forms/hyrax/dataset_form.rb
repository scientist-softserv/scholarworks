# Generated via
#  `rails generate hyrax:work Dataset`
#
# Fields to show in DataSet form
#
module Hyrax
  class DatasetForm < Hyrax::CsuForm
    self.model_class = ::Dataset
    self.required_fields += %i[title
                               description
                               methods_of_collection
                               date_range]

    def primary_terms
      %i[title
         creator
         description
         methods_of_collection
         date_range
         data_note
         date_last_modified
         sponsor
         award_number
         doi
         identifier
         rights_note
         license
         keyword
         subject
         related_url
         language
         department
         discipline
         data_type]
    end
  end
end
