class Receipt < ActiveRecord::Base

  belongs_to :delivery
  belongs_to :recipient, class_name: :User

  validates :delivery_id, :recipient_id, presence: true
  validates :number_packages, numericality: true

  accepts_nested_attributes_for :recipient

  attr_accessible :number_packages,
                  :recipient_id,
                  :comment,
                  :delivery_id

  delegate :worker, :deliverer, to: :delivery

  after_create do
    PackageMailer.deliver_receipt(self).deliver
  end

  def signed_out?
    !(read_attribute(:signed_out_at)).nil?
  end

  def sign_out!
    self.signed_out_at = Time.zone.now
    self.save
  end
end
