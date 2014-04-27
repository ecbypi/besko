class Mailer < ActionMailer::Base

  def package_confirmation(receipt_id)
    @receipt   = Receipt.find(receipt_id)
    @delivery  = @receipt.delivery
    @recipient = @receipt.user
    @worker    = @delivery.user

    mail(
      to: @recipient.email,
      from: "#{@worker.name} <#{@worker.email}>",
      subject: default_i18n_subject(deliverer: @delivery.deliverer)
    )
  end
end
