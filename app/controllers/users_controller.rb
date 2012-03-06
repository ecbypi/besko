class UsersController < ApplicationController
  respond_to :json

  def index
    users = User.recipients(params[:term] || "", use_ldap: params[:remote])
    respond_with(users)
  end
end
