class DeliverySerializer < ApplicationSerializer
  attributes :id, :deliverer, :package_count, :created_at, :delivered_at

  has_one :worker, serializer: UserSerializer, include: true, embed: :ids
  has_many :receipts

  def delivered_at
    object.created_at.strftime('%r')
  end
end
