class ApplicationController < ActionController::Base
  protect_from_forgery
  expose(:current_user_session) { UserSession.find }
  expose(:current_user) { current_user_session.try(:user) }
end
