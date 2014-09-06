class ShibbolethSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    shibboleth_login_handler = URI.parse(ENV["SHIBBOLETH_LOGIN_HANDLER"]) rescue nil

    if shibboleth_login_handler
      shibboleth_login_handler.query = { target: new_user_session_url }.to_param
      redirect_to shibboleth_login_handler.to_s
    else
      redirect_to new_user_session_url
    end
  end
end
