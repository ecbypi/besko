class DeliverySerializer < ApplicationSerializer
  attributes :id, :deliverer, :package_count, :created_at, :deletable
  attribute :created_at, key: :delivered_at

  has_one :user, include: true, embed: :ids
  has_many :receipts

  def deletable
    scope.admin?
  end

  def include_deletable?
    scope.admin?
  end
end
