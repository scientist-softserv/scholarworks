# frozen_string_literal: true

#
# Degree name authority
#
class DegreeNamesService < AuthorityService
  def initialize(controller)
    super('degree_names', controller, model: true)
  end
end
