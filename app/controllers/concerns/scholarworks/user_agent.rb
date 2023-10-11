# frozen_string_literal: true

module Scholarworks
  module UserAgent
    #
    # Check for user agents we don't want to track
    #
    # @param request [ActionDispatch::Request]
    #
    # @return [Boolean]
    #
    def self.is_bad?(request)
      return true if request.is_crawler?
      return true if request.user_agent.blank?
      return true unless request.user_agent.include?('/')

      false
    end
  end
end
