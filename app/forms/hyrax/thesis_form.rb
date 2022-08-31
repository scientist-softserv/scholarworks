# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisForm < Hyrax::CsuForm
    self.model_class = ::Thesis
    self.required_fields += %i[resource_type
                               title
                               creator
                               description
                               degree_name]
    def primary_terms
      %i[resource_type
         title
         creator
         description
         date_issued
         degree_name
         degree_program
         advisor
         committee_member
         department
         discipline
         keyword
         language
         license]
    end
  end
end
