class ForwardingAddressResponder < ActionController::Responder
  include Responders::FlashResponder

  def navigation_behavior(error)
    if get?
      raise error
    elsif has_errors?
      render 'devise/registrations/edit'
    else
      redirect_to :edit_user_registration
    end
  end
end
