class HandleRegisterJob < ApplicationJob
  def perform(resource)

    # TODO: support paths for non-thesis work types
    path = Rails.application.routes.url_helpers.hyrax_thesis_path(resource)
    HandleService.register(resource, path)
  end
end