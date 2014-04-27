class DeliveryDecorator < ApplicationDecorator
  def time_of_delivery
    object.created_at.strftime('%I:%M:%S %P')
  end

  def formatted_delivered_on
    object.delivered_on.strftime('%A, %B %d, %Y')
  end
end
