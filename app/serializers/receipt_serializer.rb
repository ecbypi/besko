class ReceiptSerializer < ApplicationSerializer
  attributes :id, :number_packages, :comment, :created_at

  has_one :user, include: true, embed: :ids
end
