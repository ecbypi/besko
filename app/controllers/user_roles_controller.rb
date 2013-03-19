class UserRolesController < ApplicationController
  respond_to :html, only: :index
  respond_to :json
  authorize_resource

  def index
    user_roles = params[:title] ? UserRole.with_title(params[:title]).order { id.desc } : []

    respond_with(user_roles, root: :roles)
  end

  def show
    render :index
  end

  def create
    role = UserRole.create(params[:user_role])

    respond_with(role)
  end

  def destroy
    UserRole.find(params[:id]).destroy

    head :no_content
  end
end
