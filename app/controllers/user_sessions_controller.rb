class UserSessionsController < ApplicationController
  expose(:user_session) { UserSession.new }
  def create
    if UserSession.create(params[:user_session])
      redirect_to :root, :notice => "Login Successful"
    else
      render :action => :new
    end
  end
end
