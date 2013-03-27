class ReceiptSerializer < ApplicationSerializer
  attributes :id, :number_packages, :comment, :created_at

  has_one :recipient, include: true, embed: :ids
end
