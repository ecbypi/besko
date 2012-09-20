class UserRoleSerializer < ApplicationSerializer
  attributes :id, :name, :added

  def name
    object.user.name
  end

  def added
    object.created_at.strftime('%c')
  end
end
