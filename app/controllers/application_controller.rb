class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.html { redirect_to :root }
    end
  end
end
