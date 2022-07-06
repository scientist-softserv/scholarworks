# Generated via
#  `rails generate hyrax:work Archive`
module Hyrax
  class ArchiveForm < Hyrax::CsuForm
    self.model_class = Archive
    def primary_terms
      %i[title
         alternative_title
         creator
         contributor
         resource_type
         description
         description_note
         table_of_contents
         keyword
         subject
         geographical_area
         time_period
         rights_note
         rights_access
         license
         rights_holder
         source
         date_accepted
         date_available
         date_copyright
         date_created
         date_issued
         date_modified
         date_submitted
         date_valid
         format
         extent
         medium
         identifier
         bibliographic_citation
         instructional_method
         language
         provenance
         publisher
         relation
         conforms_to
         has_format
         has_part
         has_version
         is_format_of
         is_referenced_by
         is_replaced_by
         is_required_by
         is_version_of
         references
         replaces
         requires
         accrual_periodicity
         accrual_policy
         accrual_method
         audience
         education_level
         mediator
         coverage]
    end
  end
end
