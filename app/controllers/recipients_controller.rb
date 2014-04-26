class RecipientsController < UsersController
  def create
    recipient = Recipient.new(recipient_params)

    authorize!(:create, recipient)

    recipient.assign_password.skip_confirmation_email!
    recipient.save

    respond_with(recipient, location: user_url(recipient))
  end

  private

  def recipient_params
    params.require(:recipient).permit(:first_name, :last_name, :street, :login, :email)
  end
end
