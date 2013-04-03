class ApplicationDecorator < Draper::Base

  def format_timestamp(column)
    model.send(column).strftime(time_format)
  end

  private

  def time_format
    '%l:%M %p on %b %d, %Y'
  end
end
