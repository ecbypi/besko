class UserRolesController < InheritedResources::Base
  respond_to :html, :json

  protected

  def collection
    @user_roles ||= UserRole.with_title(params[:title]).order { id.desc }
  end
end
