class User < ActiveRecord::Base
  REQUIRED_LDAP_ATTRIBUTES = %w( givenName sn mail ).freeze
  LDAP_ATTRIBUTES = {
    'givenName' => 'first_name',
    'sn'        => 'last_name',
    'mail'      => 'email',
    'street'    => 'street',
    'uid'       => 'login'
  }.freeze

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

  has_one :forwarding_address

  has_guises :DeskWorker, :Admin, association: :user_roles, attribute: :title

  validates :first_name, :last_name, presence: true
  validates :login, uniqueness: { allow_nil: true, case_sensitive: false }

  def self.guise_options
    Guise.registry[self.table_name.classify]
  end

  def self.guises
    guise_options[:names]
  end

  def self.guise_titles
    guises.map { |title| [title.titleize, title] }
  end

  def self.search(query)
    terms = query.split
    likened_terms = terms.map { |term| "#{term}%" }

    where do
      ( concat(first_name, ' ', last_name).like "#{query}%" ) |
      ( last_name.like "#{terms.last}%"  ) |
      ( email.like_any likened_terms     ) |
      ( login.like_any likened_terms     )
    end
  end

  def self.directory_search(query)
    results = DirectorySearch.search(query)

    users = results.map do |result|
      next nil unless REQUIRED_LDAP_ATTRIBUTES.map { |key| result[key].present? }.all?

      attributes = LDAP_ATTRIBUTES.inject({}) do |attrs, (key, column)|
        attrs[column] = result.fetch(key, '')
        attrs
      end

      User.new(attributes)
    end

    users.compact
  end

  def assign_password
    self.password = self.password_confirmation = Devise.friendly_token

    self
  end

  def name
    "#{first_name} #{last_name}"
  end

  def active_for_authentication?
    !!activated_at? && super
  end

  def activate!
    update(activated_at: Time.zone.now)
  end

  private

  def send_on_create_confirmation_instructions
    false
  end

  def password_required?
    forwarding_account ? false : super
  end
end
