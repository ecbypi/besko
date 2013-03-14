class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :email, :login, :street

  def include_id?
    object.id.present?
  end

  def include_street?
    object.street.present?
  end
end
