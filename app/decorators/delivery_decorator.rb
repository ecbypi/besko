class DeliveryDecorator < ApplicationDecorator
  decorates :delivery

  def as_json options={}
    model.as_json(
      include: [:worker],
      except: [:updated_at, :delivered_on],
      methods: [:package_count]
    ).merge(
      delivered_at: model.created_at.strftime('%r')
    ).stringify_keys
  end
end
