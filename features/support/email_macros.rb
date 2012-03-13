module EmailMacros

  def last_email
    ActionMailer::Base.deliveries.last
  end
end

World(EmailMacros)
