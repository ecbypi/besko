class UserSessionsController < ApplicationController
  expose(:user_session) { UserSession.new(params[:user_session]) }
  expose(:user) { User.find_by_email_or_login(params[:user_session] && params[:user_session][:login]) }
  def create
    if user_session.save
      redirect_to :root, :notice => "Login Successful"
    else
      flash.now[:alert] = user.present? ? "Your account has not been approved" : "Invalid credentials"
      render :action => :new
    end
  end
end
