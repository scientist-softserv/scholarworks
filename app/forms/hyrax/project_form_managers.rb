# Generated via
#  `rails generate hyrax:work Project`
#
# Fields to show in Project form for managers
#
module Hyrax
  class ProjectFormManagers < ThesisFormManagers
    self.model_class = ::Project
    self.required_fields -= %i[advisor degree_name department]
  end
end
