module EmailMacros

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def last_email_body
    last_email.body.encoded
  end

  def reset_email
    ActionMailer::Base.deliveries.clear
  end
end
