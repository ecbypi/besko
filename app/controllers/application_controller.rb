class ApplicationController < ActionController::Base
  protect_from_forgery

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

  def authorize_resource!
    CanCan::ControllerResource.new(self).authorize_resource
  end
end
