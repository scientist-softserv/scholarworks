# frozen_string_literal: true

#
# Data type authority
#
class DataTypeService < AuthorityService
  def initialize(controller)
    super('data_type', controller)
  end
end
