# Generated via
#  `rails generate hyrax:work Archive`
module Hyrax
  class ArchiveForm < Hyrax::CsuForm
    self.model_class = Archive
    self.required_fields += %i[title
                               creator
                               description]
    def primary_terms
      %i[title
         alternative_title
         description
         description_note
         creator
         interviewee
         interviewer
         subject
         geographical_area
         date_created
         identifier
         rights_statement
         rights_holder
         language
         publisher
         repository
         source
         is_part_of
         has_finding_aid
         related_url
         work_type
         format
         extent
         institution]
    end
  end
end
