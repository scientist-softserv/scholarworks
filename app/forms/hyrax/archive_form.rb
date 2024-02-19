# Generated via
#  `rails generate hyrax:work Archive`
#
# Fields to show in Archive form
#
module Hyrax
  class ArchiveForm < Hyrax::CsuForm
    self.model_class = Archive
    self.required_fields += %i[title]
    def primary_terms
      %i[resource_type
         title
         alternative_title
         creator
         contributor
         description
         description_note
         subject
         keyword
         geographical_area
         date_created
         identifier
         rights_statement
         rights_note
         rights_holder
         language
         publisher
         repository
         source
         sponsor
         funding_code
         is_part_of
         digital_project
         has_finding_aid
         related_url
         work_type
         format
         file_format
         extent
         institution]
    end
  end
end
