class Receipt < ActiveRecord::Base

  belongs_to :delivery
  belongs_to :user
  has_one :worker, through: :delivery, source: :user

  validates :user_id, presence: true
  validates :delivery_id, presence: { on: :update }
  validates :number_packages, numericality: true

  attr_accessible :number_packages,
                  :user_id,
                  :comment,
                  :delivery_id

  delegate :deliverer, to: :delivery

  def signed_out?
    !(read_attribute(:signed_out_at)).nil?
  end

  def sign_out!
    self.signed_out_at = Time.zone.now
    self.save
  end
end
