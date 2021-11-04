# frozen_string_literal: true

#
# Thesis resource types authority
#
class ResourceTypesThesisService < AuthorityService
  def initialize(controller)
    super('resource_types_thesis', controller)
  end
end
