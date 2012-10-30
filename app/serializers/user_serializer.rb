class UserSerializer < ApplicationSerializer
  attributes :id, :first_name, :last_name, :email, :login, :street
end
