class PackageDecorator < ApplicationDecorator
  decorates :package

  def received_at
    model.created_at.strftime(time_format)
  end

  def recipient_name
    model.recipient.name
  end

  def mail_to_worker
    h.mail_to model.worker.email, model.worker.name
  end

  private

  def time_format
    '%B %d, %Y at %r'
  end
end
