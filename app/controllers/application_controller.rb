class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController

  with_themed_layout '1_column'

  protect_from_forgery with: :exception
  rescue_from StandardError, with: :deal_with_exception unless Rails.application.config.consider_all_requests_local
  skip_after_action :discard_flash_if_xhr

  # all missing routes end up here
  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  protected

  # no need for locale, since we only use English
  # this removes it from params when generating urls
  def default_url_options
    super.except!(:locale)
  end

  private

  def after_sign_out_path_for(*)
    '/Shibboleth.sso/Logout'
  end

  #
  # Log the exception appropriately and present error page
  #
  # @param exception [StandardError]
  #
  def deal_with_exception(exception = nil)
    return if exception.nil?

    # we assume the exception is an application error worth fully logging and inspecting later
    error_code = 500
    error_label = 'SERVER ERROR'
    use_layout = true

    # unless it's one of these common access or invalid request errors, most caused by bots
    not_found = %w[ActionController::RoutingError
                   ActiveRecord::RecordNotFound
                   ActiveFedora::ObjectNotFoundError
                   Blacklight::Exceptions::RecordNotFound
                   Ldp::Gone]
    no_access = %w[CanCan::AccessDenied]
    not_valid = %w[I18n::InvalidLocale]

    # let's find out if it's one of the above
    class_name = exception.class.to_s

    if not_found.include?(class_name)
      error_code = 404
      error_label = 'NOT FOUND'
    elsif no_access.include?(class_name)
      error_code = 401
      error_label = 'ACCESS DENIED'
    elsif not_valid.include?(class_name)
      error_code = 422
      error_label = 'REJECTED'
    end

    # for common errors: just log the reason, ip address & path in a separate log file
    # for application errors: log the full stack trace in the main error log file
    if error_code != 500
      line = [error_label, request.ip, request.fullpath].join("\t")
      Logger.new('log/access_error.log').info(line)
    else
      Rails.logger.warn "[#{request.ip}] #{request.fullpath}"
      Rails.logger.error "#{class_name}: #{exception.message}"
      Rails.logger.error Rails.backtrace_cleaner.clean(exception.backtrace)
    end

    # response to client
    respond_to do |format|
      # for html pages: give them the full response
      format.html { render file: "#{Rails.root}/public/#{error_code}.html", status: error_code, layout: 'error' }

      # for non-html stuff: respond with just the header
      # content_type set here to stop X-XSS errors for missing .js files
      format.any { head error_code, content_type: 'text/html' }
    end
  end
end
