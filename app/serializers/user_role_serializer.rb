class UserRoleSerializer < ApplicationSerializer
  attributes :id, :created_at

  has_one :user, include: true, embed: :ids
end
