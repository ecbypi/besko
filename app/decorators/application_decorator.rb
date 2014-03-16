class ApplicationDecorator < Draper::Decorator

  def format_timestamp(column)
    object.send(column).strftime(time_format)
  end

  private

  def time_format
    '%l:%M %p on %b %d, %Y'
  end
end
