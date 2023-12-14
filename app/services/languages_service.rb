# frozen_string_literal: true

#
# Language authority
#
class LanguagesService < AuthorityService
  def initialize(controller)
    super('languages', controller, model: true)
  end
end
