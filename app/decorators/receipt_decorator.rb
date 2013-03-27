class ReceiptDecorator < ApplicationDecorator
  decorates :receipt

  def recipient_name
    model.user.name
  end

  def mail_to_worker
    h.mail_to model.worker.email, model.worker.name
  end

  def sign_out_button
    if model.signed_out?
      model.signed_out_at.strftime(time_format)
    else
      h.button_to 'Sign Out', h.receipt_path(model), method: :put, class: 'button'
    end
  end
end
