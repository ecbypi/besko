class UserRole < ActiveRecord::Base
  guise_for :User

  validates :user_id, presence: true

  def self.with_title(title)
    where(:title => title.to_s).includes(:user)
  end
end
