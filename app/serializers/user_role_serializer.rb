class UserRoleSerializer < ApplicationSerializer
  attributes :id, :title, :name, :added

  def name
    object.user.name
  end

  def title
    object.title.titleize
  end

  def added
    object.created_at.strftime('%c')
  end
end
