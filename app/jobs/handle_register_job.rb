class HandleRegisterJob < ApplicationJob
  def perform(resource)
    HandleService.register(resource)
  end
end