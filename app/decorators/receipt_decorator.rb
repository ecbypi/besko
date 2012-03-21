class ReceiptDecorator < ApplicationDecorator
  decorates :receipt

  def recipient_name
    model.recipient.name
  end

  def sign_out_button
    if model.signed_out?
      model.signed_out_at.strftime(time_format)
    else
      h.button_to 'Sign Out', h.receipt_path(model), method: :put, class: 'button'
    end
  end
end
