# Generated via
#  `rails generate hyrax:work Project`
module Hyrax
  class ProjectFormManagers < ThesisFormManagers
    self.model_class = ::Project
    self.required_fields -= %i[advisor degree_name department]
  end
end
