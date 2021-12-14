# frozen_string_literal: true

#
# Dataset resource types authority
#
class ResourceTypesDatasetService < AuthorityService
  def initialize(controller)
    super('resource_types_dataset', controller)
  end
end
