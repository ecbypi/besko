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

  has_many :receipts, :foreign_key => :recipient_id
  has_many :deliveries, :foreign_key => :worker_id
  has_guises :BeskWorker, :Admin, :association => :user_roles

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
    filter = {}
    arguments = query.split

    if arguments.size > 1
      filter[:cn] = arguments.join('*') + '*'
      filter[:sn] = arguments.last + '*'
      filter[:mail] = filter[:uid] = arguments
    else
      filter[:uid] = filter[:mail] = arguments.first
      filter[:givenName] = arguments.first
      filter[:sn] = arguments.first + '*'
    end

    filter = LDAP::Filter::OrFilter.new(filter)

    results = MIT::LDAP.search(
      filter: filter.to_s,
      limit: 20,
      instantiate: false,
      attributes: LDAP_ATTRIBUTES.keys
    )

    users = results.map do |result|
      next nil unless REQUIRED_LDAP_ATTRIBUTES.map { |key| result[key].present? }.all?

      attributes = LDAP_ATTRIBUTES.inject({}) do |attrs, (key, column)|
        attrs[column] = result[key].first
        attrs
      end

      User.new(attributes)
    end

    users.compact
  end

  def self.assign_password(user)
    user = User.new(user) if user.is_a? Hash

    password = send(:generate_token, 'encrypted_password')
    password.slice!(13 - rand(5)..password.length)

    user.password = user.password_confirmation = password
    user
  end

  def name
    "#{first_name} #{last_name}"
  end

  def headers_for(action)
    headers = {}
    headers[:to] = 'besko@mit.edu' if action == :confirmation_instructions
    headers
  end

  def skip_confirmation_email!
    @skip_confirmation_email = true
  end

  private

  def send_on_create_confirmation_instructions
    super unless @skip_confirmation_email
  end
end
