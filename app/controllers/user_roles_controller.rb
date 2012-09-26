class UserRolesController < InheritedResources::Base
  respond_to :html, :json
  authorize_resource

  protected

  def collection
    @user_roles ||= params[:title] ? UserRole.with_title(params[:title]).order { id.desc } : []
  end
end
