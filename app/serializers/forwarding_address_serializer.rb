class ForwardingAddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :street, :city, :state, :country, :postal_code

  def name
    object.user.name
  end
end
