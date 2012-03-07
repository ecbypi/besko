module DeliveriesHelper

  def previous_delivery_date attribute
    delivery_date(attribute) - 1.day
  end

  def next_delivery_date attribute
    delivery_date(attribute) + 1.day
  end

  def delivery_date attribute
    return Time.zone.now.to_date unless attribute
    Date.parse(attribute.values.map(&:value).first)
  end
end
