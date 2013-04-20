class ApplicationDecorator < Draper::Decorator

  def format_timestamp(column)
    source.send(column).strftime(time_format)
  end

  private

  def time_format
    '%l:%M %p on %b %d, %Y'
  end
end
