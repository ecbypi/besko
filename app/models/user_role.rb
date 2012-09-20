class UserRole < ActiveRecord::Base
  guise_for :user

  def self.with_title(title)
    where(:title => title.to_s).includes(:user)
  end
end
