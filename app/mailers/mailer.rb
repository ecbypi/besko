class Mailer < ActionMailer::Base

  def package_confirmation(receipt_id)
    @receipt   = Receipt.find(receipt_id)
    @delivery  = @receipt.delivery
    @recipient = @receipt.user
    @worker    = @delivery.user

    mail to: @recipient.email, from: @worker.email, subject: 'Delivery at Besk'
  end
end
