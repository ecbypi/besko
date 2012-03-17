class UsersController < ApplicationController
  respond_to :json

  def index
    users = UserDecorator.decorate User.lookup(params[:term])
    respond_with users.map { |user| user.as_json(as_autocomplete: params[:autocomplete]) }
  end

  def create
    respond_with User.create_with_or_without_password(params[:user])
  end
end
