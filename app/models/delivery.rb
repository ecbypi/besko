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

  belongs_to :user
  has_many :receipts, dependent: :delete_all, inverse_of: :delivery
  has_many :recipients, through: :receipts, source: :user

  validates :deliverer, :user, :receipts, presence: true

  accepts_nested_attributes_for :receipts

  before_create do
    self.delivered_on ||= Time.zone.now.to_date
  end

  after_create do
    recipients.where(:confirmed_at => nil).update_all(:confirmed_at => Time.zone.now)
  end

  def self.delivered_on(date = nil)
    date = date.blank? ? Time.zone.now.to_date : Time.zone.parse(date).to_date

    where(:delivered_on => date)
  end

  def package_count
    receipts.map(&:number_packages).reduce(:+)
  end
end
