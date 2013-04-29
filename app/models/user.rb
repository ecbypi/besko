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
         :token_authenticatable,
         :confirmable

  has_many :receipts
  has_many :deliveries

  has_many :previous_addresses

  has_guises :BeskWorker, :Admin, :Resident, :association => :user_roles

  validates :first_name, :last_name, presence: true
  validates :login, uniqueness: { allow_nil: true, case_sensitive: false }

  attr_accessible :first_name,
                  :last_name,
                  :login,
                  :email,
                  :street,
                  :password,
                  :password_confirmation

  def self.guise_titles
    guises.map { |title| [title.titleize, title] }
  end

  def self.search(query)
    terms = query.split

    name_match = query.gsub(/\s+/, '%') + '%'
    likened_terms = terms.map { |term| "#{term}%" }

    where do
      ( concat(first_name, ' ', last_name).like query + '%' ) |
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

  def update_address!(address)
    transaction do
      previous_addresses.create(
        address: self.street,
        preceded_by_id: previous_address_ids.last
      )

      self.update_attributes(street: address)
    end
  end

  def assign_password
    self.password = self.password_confirmation = self.class.send(:generate_token, 'encrypted_password')

    self.password.slice!(13 - rand(5)..password.length)

    self
  end

  def name
    "#{first_name} #{last_name}"
  end

  def skip_confirmation_email!
    @skip_confirmation_email = true
  end

  private

  def send_on_create_confirmation_instructions
    unless @skip_confirmation_email
      self.devise_mailer.delay.confirmation_instructions(self)
    end
  end
end
