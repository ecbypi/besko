class AccountsMailer < Devise::Mailer

  def confirmation_instructions(user, options = {})
    devise_mail(user, :confirmation_instructions, to: 'besko@mit.edu')
  end
end
