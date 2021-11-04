# frozen_string_literal: true

#
# Departments authority
#
class DepartmentsService < AuthorityService
  def initialize(controller)
    super('departments', controller)
  end
end
