# frozen_string_literal: true

#
# Methods for usage stats
#
module StatsService
  #
  # Check for user agents we don't want to track
  #
  # @param agent [ActionDispatch::Request or String]
  #
  # @return [Boolean]
  #
  def self.bad_user_agent?(agent)
    agent_value = String.new

    if agent.is_a?(ActionDispatch::Request)
      return true if request.is_crawler?
      agent_value = request.user_agent
    elsif agent.is_a?(String)
      return true if CrawlerDetect.is_crawler?(agent)
      agent_value = agent
    else
      raise ArgumentError 'value must be of type ActionDispatch::Request or String'
    end

    return true if agent_value.blank?
    return true if agent_value.include?('@')
    return true unless agent_value.include?('/')

    false
  end
end
