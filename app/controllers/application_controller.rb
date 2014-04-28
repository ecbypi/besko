class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :sign_in_with_touchstone
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        path = if current_user && request.env['HTTP_REFERER']
                 :back
               elsif current_user
                 :root
               else
                 :new_user_session
               end
        redirect_to path, alert: "Access Denied: #{exception.message}"
      end
      format.json { head :unauthorized }
    end
  end

  private

  def sign_in_with_touchstone
    if request.env['REMOTE_USER']
      user = User.find_by_email(request.env['REMOTE_USER'])
      sign_in(user) if user
    end
  end
end
