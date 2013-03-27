class PackageMailer < ActionMailer::Base

  def self.send_receipts(delivery)
    delivery.receipts.each do |receipt|
      confirmation(receipt).deliver
    end
  end

  def confirmation(receipt)
    @receipt   = receipt
    @delivery  = receipt.delivery
    @recipient = receipt.user
    @worker    = @delivery.user

    mail to: @recipient.email, from: @worker.email, subject: 'Delivery at Besk'
  end
end
