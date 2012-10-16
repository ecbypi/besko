class UserSerializer < ApplicationSerializer
  attributes :id, :name, :first_name, :last_name, :email, :login, :street, :label, :value, :details

  def label
    object.name
  end

  def value
    object.login
  end

  def details
    [object.email, object.street].compact.join(' | ')
  end
end
