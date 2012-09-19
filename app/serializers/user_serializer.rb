class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :first_name, :last_name, :email, :login, :street, :label, :value

  def label
    object.name
  end

  def value
    object.login
  end
end
