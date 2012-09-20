class UsersController < ApplicationController
  respond_to :json

  def index
    respond_with(User.lookup(params[:term], params[:options]))
  end

  def create
    user = User.assign_password(params[:user])
    user.save

    respond_with(user)
  end
end
