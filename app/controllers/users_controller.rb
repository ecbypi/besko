class UsersController < ApplicationController
  respond_to :json

  def index
    users = User.recipients(params[:term] || "", use_ldap: params[:remote])
    respond_with(users)
  end

  def create
    respond_with User.create_with_or_without_password(params[:user])
  end
end
