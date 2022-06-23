# frozen_string_literal: true

#
# Project resource types authority
#
class ResourceTypesService < AuthorityService
  def initialize(controller)
    authority_name = 'resource_types'
    if controller.class.method_defined?(:curation_concern)
      authority_name += '_' + controller.curation_concern.class.name.downcase
    end
    super(authority_name, controller)
  end
end
