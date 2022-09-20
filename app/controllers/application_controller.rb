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
  skip_after_action :discard_flash_if_xhr # 2.1.0 upgrade

  def not_found
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => true
  end

  private

  def after_sign_out_path_for(*)
    '/Shibboleth.sso/Logout'
  end
end
