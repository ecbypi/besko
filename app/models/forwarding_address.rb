class ForwardingAddress < ActiveRecord::Base
  belongs_to :user

  validates :street, :city, :state, :country, :postal_code, :user_id, presence: true
end
