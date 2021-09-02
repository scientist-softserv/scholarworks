# frozen_string_literal: true

module Users
  # session controller to redirect the user to shib login path
  class SessionsController < Devise::SessionsController
    def new
      Rails.logger.debug "SessionsController#new: request.referer = #{request.referer}"
      if Settings.require_shib_user_authn && params[:direct].blank?
        store_location_for(:user, '/dashboard')
        redirect_to user_shibboleth_omniauth_authorize_path
      else
        super
      end
    end

    def after_sign_out_path_for(scope)
      return Settings.sso_logout_url if Settings.require_shib_user_authn
      super
    end
  end
end
