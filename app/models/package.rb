class Package < ActiveRecord::Base
  belongs_to :worker, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'

  def self.for_date(date)
    where(:received_on => date)
  end

  def received_by
    worker
  end

  def signed_out?
    !(read_attribute(:signed_out_at)).nil?
  end

  def sign_out!
    self.signed_out_at = Time.zone.now and save
  end

  def received_at
    created_at.strftime("%Y-%m-%d at %r")
  end
end
