class User < ActiveRecord::Base
  acts_as_authentic

  has_many :received_packages, :class_name => 'Package', :foreign_key => :recipient_id
  has_many :mailed_packages, :class_name => 'Package', :foreign_key => :worker_id
  has_and_belongs_to_many :roles

  def self.find_by_email_or_login(field)
    find_by_email(field) || find_by_login(field)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def has_role?(title)
    title = title.to_s.titleize if title.is_a?(Symbol)
    roles.collect { |role| role.title }.include?(title)
  end
end
