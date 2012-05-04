class UserRole < ActiveRecord::Base
  belongs_to :user
  validates :user_id, uniqueness: { scope: :title }
end
