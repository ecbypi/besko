class Delivery < ActiveRecord::Base

  belongs_to :worker, class_name: 'User'
  has_many :receipts

  validates :deliverer, presence: true
end
