class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :trackable,
         :validatable,
         :lockable,
         :timeoutable,
         :confirmable,
         reconfirmable: false

  has_many :receipts
  has_many :deliveries

  has_guises :DeskWorker, :Admin, association: :user_roles, attribute: :title

  validates :first_name, :last_name, presence: true
  validates :login, uniqueness: { allow_nil: true, case_sensitive: false }

  def self.search(query)
    SearchQuery.new(query).result
  end

  def assign_password
    self.password = self.password_confirmation = Devise.friendly_token

    self
  end

  def name
    "#{first_name} #{last_name}"
  end

  def active_for_authentication?
    activated? && super
  end

  def activate!
    update(activated_at: Time.zone.now)
  end

  def activated?
    !!activated_at
  end

  private

  def send_on_create_confirmation_instructions
    false
  end

  def password_required?
    forwarding_account ? false : super
  end
end
