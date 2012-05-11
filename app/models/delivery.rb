class Delivery < ActiveRecord::Base

  belongs_to :worker, class_name: 'User'
  has_many :receipts

  validates :deliverer, :worker_id, presence: true

  accepts_nested_attributes_for :receipts

  attr_accessible :deliverer, :delivered_on, :receipts_attributes

  before_save do
    self.delivered_on = Date.today unless self.delivered_on
  end

  def self.delivered_on date=nil
    date ||= Date.today
    where{delivered_on.eq date}
  end

  def package_count
    receipts.map(&:number_packages).reduce(:+)
  end
end
