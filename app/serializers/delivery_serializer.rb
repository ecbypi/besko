class DeliverySerializer < ApplicationSerializer
  attributes :id, :deliverer, :package_count, :created_at, :delivered_at, :deletable

  has_one :user, include: true, embed: :ids
  has_many :receipts

  def delivered_at
    object.created_at.strftime('%r')
  end

  def deletable
    scope.admin?
  end

  def include_deletable?
    scope.admin?
  end
end
