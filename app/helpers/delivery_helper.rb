module DeliveryHelper
  def current_date
    date = params[:date] ? Date.parse(params[:date]) : Date.today
    date.strftime('%A, %B %d, %Y')
  end
end
