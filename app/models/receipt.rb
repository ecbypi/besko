class Receipt < ActiveRecord::Base

  belongs_to :delivery
  belongs_to :recipient, class_name: 'User'

  def signed_out?
    !(read_attribute(:signed_out_at)).nil?
  end

  def sign_out!
    self.signed_out_at = Time.zone.now
    self.save
  end
end
