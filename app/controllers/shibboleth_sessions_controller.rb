class ShibbolethSessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    shibboleth_login_handler = URI.parse(ENV["SHIBBOLETH_LOGIN_HANDLER"]) rescue nil

    if shibboleth_login_handler
      redirect_to shibboleth_login_handler.to_s
    else
      redirect_to new_user_session_url
    end
  end
end
