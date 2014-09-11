class Receipt < ActiveRecord::Base

  belongs_to :delivery, inverse_of: :receipts, touch: true
  belongs_to :user
  has_one :worker, through: :delivery, source: :user

  validates :user, :delivery, presence: true
  validates :number_packages, numericality: true

  def signed_out?
    !!signed_out_at
  end
end
