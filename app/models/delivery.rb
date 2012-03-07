class Delivery < ActiveRecord::Base

  belongs_to :worker, class_name: 'User'
  has_many :receipts

  validates :deliverer, presence: true

  before_save do
    self.delivered_on = Date.today unless self.delivered_on
  end

  def package_count
    receipts.map(&:number_packages).reduce(:+)
  end
end
