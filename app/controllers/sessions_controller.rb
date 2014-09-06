class SessionsController < Devise::SessionsController

  before_action :authenticate_via_touchstone!, only: :new

  private

  def authenticate_via_touchstone!
    identifier = request.env["REMOTE_USER"]

    if identifier && user = User.find_by(email: identifier)
      sign_in user
      redirect_to after_sign_in_path_for(user)
    end
  end

  def after_sign_in_path_for(user)
    receipts_url
  end
end
