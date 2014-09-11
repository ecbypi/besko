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
    self.delivered_on ||= Time.zone.today
  end

  after_create do
    now = Time.zone.now
    recipients.where(:confirmed_at => nil).update_all(:confirmed_at => now, :activated_at => now)
  end

  def self.waiting_for_pickup
    joins(:receipts).where(receipts: { signed_out_at: nil }).uniq
  end

  def package_count
    receipts.map(&:number_packages).reduce(:+)
  end
end
