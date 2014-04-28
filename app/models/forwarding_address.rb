class ForwardingAddress < ActiveRecord::Base
  belongs_to :user

  validates :street, :city, :state, :country, :postal_code, :user, presence: true
end
