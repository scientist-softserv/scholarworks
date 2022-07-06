# Generated via
#  `rails generate hyrax:work Thesis`
module Hyrax
  class ThesisFormManagersPomona < ThesisFormManagers
    self.required_fields += %i[resource_type
                               title
                               creator
                               description
                               degree_name]
  end
end
