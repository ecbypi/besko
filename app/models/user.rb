class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :trackable,
         :validatable,
         :lockable,
         :timeoutable,
         :token_authenticatable,
         :confirmable

  has_many :received_packages, :class_name => 'Package', :foreign_key => :recipient_id
  has_many :mailed_packages, :class_name => 'Package', :foreign_key => :worker_id
  has_and_belongs_to_many :roles

  attr_accessible :first_name,
                  :last_name,
                  :login,
                  :email,
                  :password,
                  :password_confirmation

  def name
    "#{first_name} #{last_name}"
  end

  def has_role?(title)
    title = title.to_s.titleize if title.is_a?(Symbol)
    roles.collect { |role| role.title }.include?(title)
  end
end
