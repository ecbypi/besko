class Receipt < ActiveRecord::Base

  has_many :packages
  belongs_to :delivery
  belongs_to :recipient, class_name: 'User'
end
