class PackageMailer < ActionMailer::Base

  def self.send_receipts(delivery)
    delivery.receipts.each do |receipt|
      delay.confirmation(receipt.id)
    end
  end

  def confirmation(receipt_id)
    @receipt   = Receipt.find(receipt_id)
    @delivery  = @receipt.delivery
    @recipient = @receipt.user
    @worker    = @delivery.user

    mail to: @recipient.email, from: @worker.email, subject: 'Delivery at Besk'
  end
end
