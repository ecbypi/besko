class ReceiptSerializer < ActiveModel::Serializer
  attributes :number_packages, :comment, :created_at

  has_one :recipient, serializer: UserSerializer
end
