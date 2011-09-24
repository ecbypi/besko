class UserSessionsController < ApplicationController
  expose(:user_session) { UserSession.new(params[:user_session]) }
  def create
    if user_session.save
      redirect_to :root, :notice => "Login Successful"
    else
      flash.now[:alert] = "Invalid credentials"
      render :action => :new
    end
  end
end
