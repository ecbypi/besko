class Delivery < ActiveRecord::Base

  Deliverers = [
    'UPS',
    'USPS / Post Office',
    'FedEx',
    'LaserShip',
    'Amazon',
    'DHL',
    'Interdepartmental',
    'Laundry Service',
    'Student / Personal',
    'Other'
  ]

  belongs_to :worker, class_name: :User
  has_many :receipts
  has_many :recipients, through: :receipts

  validates :deliverer, :worker_id, presence: true

  accepts_nested_attributes_for :receipts

  attr_accessible :deliverer,
                  :delivered_on,
                  :receipts_attributes

  before_create do
    self.delivered_on = Date.today unless self.delivered_on
  end

  after_create do
    recipients.where(:confirmed_at => nil).update_all(:confirmed_at => Time.zone.now)
  end

  def self.delivered_on(date = nil)
    date ||= Date.today

    where(:delivered_on => date)
  end

  def package_count
    receipts.map(&:number_packages).reduce(:+)
  end
end
