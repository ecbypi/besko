class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates :title, :uniqueness => {:case_sensitive => false}
end
