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
  skip_after_action :discard_flash_if_xhr # 2.1.0 upgrade

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def after_sign_out_path_for(*)
    '/Shibboleth.sso/Logout'
  end

  def handle_exception(exception=nil)
    Rails.logger.error "handle_exception #{exception.class}"
    if exception
      error_code = 'ActionController::RoutingError ActiveRecord::RecordNotFound, ActiveFedora::ObjectNotFoundError, Blacklight::Exceptions::RecordNotFound'.include?(exception.class.to_s) ? 404 : 500
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/#{error_code}.html", :status => error_code, :layout => true }
        format.all { render nothing: true, status: status }
      end
    end
  end

end
