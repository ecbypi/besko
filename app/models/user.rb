class User < ActiveRecord::Base
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
  has_and_belongs_to_many :roles

  attr_accessible :first_name,
                  :last_name,
                  :login,
                  :email,
                  :street,
                  :password,
                  :password_confirmation

  def self.lookup search=nil, options={}
    options.reverse_merge!(
      skip_ldap_search: false,
      ldap_search_only: false
    )

    return [] if search.blank?
    args = search.split
    results = []

    unless options[:ldap_search_only]
      first = args.first
      last = args.size > 1 ? args[1..-1].join(' ') : first
      results.concat where {
        ( first_name.eq first ) |
        ( last_name.eq  last  ) |
        ( email.in_any  args  ) |
        ( login.in_any  args  )
      }
    end

    unless options[:skip_ldap_search]
      results.concat MIT::LDAP::UserAdapter.build_users(search)
    end

    results.to_a.uniq { |user| user.login }
  end

  def self.create_with_or_without_password attributes
    unless attributes[:password] and attributes[:password_confirmation]
      password = send :generate_token, 'encrypted_password'
      password.slice! 13 - rand(5)..password.length
      attributes[:password] = attributes[:password_confirmation] = password
    end
    User.create attributes
  end

  def name
    "#{first_name} #{last_name}"
  end

  def has_role?(title)
    title = title.to_s.titleize if title.is_a?(Symbol)
    roles.collect { |role| role.title }.include?(title)
  end

  def headers_for action
    headers = {}
    headers[:to] = 'besko@mit.edu' if action == :confirmation_instructions
    headers
  end
end
