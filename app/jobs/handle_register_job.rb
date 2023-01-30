class HandleRegisterJob < Hyrax::ApplicationJob
  include Rails.application.routes.url_helpers
  def perform(resource)
    return true if resource.handle.present?

    HandleService.register(resource)
  end
end
