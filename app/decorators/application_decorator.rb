class ApplicationDecorator < Draper::Base

  def created_at
    model.created_at.strftime(time_format)
  end

  def mail_to_worker
    return '' unless model.respond_to? :worker
    h.mail_to model.worker.email, model.worker.name
  end

  private

  def time_format
    '%B %d, %Y at %l:%M %p'
  end
end
