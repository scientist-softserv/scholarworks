class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  # Adds Hyrax behaviors into the application controller
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'

  protect_from_forgery with: :exception

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| handle_exception exception }
  end

  skip_after_action :discard_flash_if_xhr

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  # no need for locale, since we only use English
  def default_url_options
    super.except!(:locale)
  end

  private

  def after_sign_out_path_for(*)
    '/Shibboleth.sso/Logout'
  end

  #
  # Log the exception and present a custom error page
  #
  def handle_exception(exception = nil)
    return if exception.nil?

    not_found = %w[ActionController::RoutingError
                   ActiveRecord::RecordNotFound
                   ActiveFedora::ObjectNotFoundError
                   Blacklight::Exceptions::RecordNotFound]
    error_code = not_found.include?(exception.class.to_s) ? 404 : 500

    # just log the path for page (or record) not found in separate log
    # otherwise the full stack trace for application errors
    if error_code == 404
      missing = "[#{request.ip}] #{request.fullpath}"
      Logger.new('log/not_found.log').info(missing)
    else
      Rails.logger.error exception.message
      Rails.logger.error exception.backtrace.join("\n")
    end

    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/#{error_code}.html", status: error_code, layout: true }
      format.all { render nothing: true, status: status }
    end
  end
end
