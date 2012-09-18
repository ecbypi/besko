class UsersController < ApplicationController
  respond_to :json

  def index
    users = UserDecorator.decorate(User.lookup(params[:term]))
    users = users.map { |user| user.as_json(as_autocomplete: params[:autocomplete]) }
    respond_with(users)
  end

  def create
    user = User.assign_password(params[:user])
    user.save

    respond_with(UserDecorator.new(user))
  end
end
