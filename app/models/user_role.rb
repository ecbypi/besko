class UserRole < ActiveRecord::Base
  guise_for :User

  validates :user, presence: true

  def self.with_title(title)
    where(:title => title.to_s).includes(:user)
  end
end
