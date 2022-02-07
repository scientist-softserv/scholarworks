# frozen_string_literal: true

#
# Colleges authority
#
class CollegesService < AuthorityService
  def initialize(controller)
    super('colleges', controller)
  end
end
