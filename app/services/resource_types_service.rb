# frozen_string_literal: true

#
# Project resource types authority
#
class ResourceTypesService < AuthorityService
  def initialize(controller)
    super('resource_types', controller, true)
  end
end
