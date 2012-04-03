class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :touchstone_sign_in

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to :root }
    end
  end

  private

  def touchstone_sign_in
    if user = User.find_by_email!(request.env['REMOTE_USER'])
      sign_in user
    end
  end
end
