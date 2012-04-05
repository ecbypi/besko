class Role < ActiveRecord::Base
  validates :title, :uniqueness => {:case_sensitive => false}
  has_many :user_roles
  has_many :users, through: :user_roles
end
