# frozen_string_literal: true

module Users
  # Class for omniauth callback once the user gets back from shibboleth
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def shibboleth
      Rails.logger.debug "OmniauthCallbacksController#shibboleth: request.env['omniauth.auth']: #{request.env['omniauth.auth']}"
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Shibboleth') if is_navigational_format?
      else
        session['devise.shibboleth_data'] = request.env['omniauth.auth']
        redirect_to root_path
      end
    end

    def failure
      redirect_to root_path
    end
  end
end
