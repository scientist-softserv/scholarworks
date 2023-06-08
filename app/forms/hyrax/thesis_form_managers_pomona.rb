# Generated via
#  `rails generate hyrax:work Thesis`
#
# Fields to show in Thesis form for Pomona campus user
#
module Hyrax
  class ThesisFormManagersPomona < ThesisFormManagers
    self.required_fields += %i[resource_type
                               title
                               creator
                               description
                               degree_name]
  end
end
