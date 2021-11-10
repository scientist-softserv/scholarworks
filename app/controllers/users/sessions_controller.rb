# frozen_string_literal: true

module Users
  # session controller to redirect the user to shib login path
  class SessionsController < Devise::SessionsController
    def new
      Rails.logger.debug "SessionsController#new: request.referer = #{request.referer}"
      if ENV['AUTHENTICATION_TYPE'] == 'shibboleth' && params[:direct].blank?
        store_location_for(:user, '/dashboard')
        redirect_to user_shibboleth_omniauth_authorize_path
      else
        super
      end
    end

    def respond_to_on_destroy
      if ENV['AUTHENTICATION_TYPE'] == 'shibboleth'
        redirect_to Settings.sso_logout_url
      else
        redirect_to '/'
      end
    end
  end
end
