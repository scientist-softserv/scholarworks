# frozen_string_literal: true

#
# Degree level authority
#
class DegreeLevelService < AuthorityService
  def initialize(controller)
    super('degree_level', controller)
  end
end
