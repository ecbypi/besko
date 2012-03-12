class PackageMailer < ActionMailer::Base

  def deliver_receipt receipt
    @receipt = receipt
    @delivery = receipt.delivery
    @recipient = receipt.recipient
    @worker = receipt.delivery.worker
    mail to: receipt.recipient.email, from: receipt.delivery.worker.email, subject: 'Delivery at Besk'
  end
end
