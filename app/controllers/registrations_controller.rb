class RegistrationsController < Devise::RegistrationsController
  private

  def resource_params
    params.require(:user).permit(
      :email,
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def after_update_path_for(resource)
    edit_registration_path(resource)
  end
end
