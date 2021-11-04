# frozen_string_literal: true

#
# Educational resource types authority
#
class ResourceTypesEducationalResourceService < AuthorityService
  def initialize(controller)
    super('resource_types_educational_resource', controller)
  end
end
