class ReceiptDecorator < ApplicationDecorator
  decorates :receipt

  def delivered_by
    model.delivery.deliverer
  end

  def received_at
    model.created_at.strftime(time_format)
  end

  def recipient_name
    model.recipient.name
  end

  def mail_to_worker
    h.mail_to model.worker.email, model.worker.name
  end

  def sign_out_button
    if model.signed_out?
      model.signed_out_at.strftime(time_format)
    else
      h.button_to 'Sign Out', h.receipt_path(model), method: :put, remote: true
    end
  end
end
