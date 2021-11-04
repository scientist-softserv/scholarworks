# frozen_string_literal: true

#
# Publication resource types authority
#
class ResourceTypesPublicationService < AuthorityService
  def initialize(controller)
    super('resource_types_publication', controller)
  end
end
