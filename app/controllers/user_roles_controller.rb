class UserRolesController < ApplicationController
  respond_to :html, only: :index
  respond_to :json
  authorize_resource

  def index
    user_roles = params[:title] ? UserRole.with_title(params[:title]) : []

    respond_with(user_roles, root: :roles)
  end

  def create
    role = UserRole.create(user_role_params)

    respond_with(role)
  end

  def destroy
    UserRole.find(params[:id]).destroy

    head :no_content
  end

  private

  def user_role_params
    params.require(:user_role).permit(:title, :user_id)
  end
end
