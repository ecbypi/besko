class ApplicationDecorator < Draper::Base

  def created_at
    model.created_at.strftime(time_format)
  end

  private

  def time_format
    '%B %d, %Y at %l:%M %p'
  end
end
