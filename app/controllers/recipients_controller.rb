class RecipientsController < ApplicationController
  respond_to :json, only: :create

  def create
    user = User.new(params[:recipient])
    user.assign_password.skip_confirmation_email!

    user.save

    respond_with(user, root: :recipient)
  end
end
