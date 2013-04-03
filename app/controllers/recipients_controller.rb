class RecipientsController < ApplicationController
  respond_to :json, only: :create

  def create
    recipient = Recipient.new(params[:recipient])

    authorize!(:create, recipient)

    recipient.assign_password.skip_confirmation_email!
    recipient.save

    respond_with(recipient, root: :recipient, location: user_url(recipient))
  end
end
