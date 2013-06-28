class ForwardingAddress < ActiveRecord::Base
  belongs_to :user

  validates :street, :city, :state, :country, :postal_code, :user_id, presence: true

  def self.search(query)
    return [] if query.blank?

    query = query.split.join('%') + '%'
    joins(:user).where { concat(user.first_name, ' ', user.last_name).like(query) }
  end
end
