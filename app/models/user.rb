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
                  :password,
                  :password_confirmation

  def self.recipients search, options={}
    options.reverse_merge! use_ldap: false
    args = search.split
    return [] if args.empty?

    first = args.first
    last = args.size > 1 ? args[1..-1].join(' ') : first
    results = where {
      ( first_name.eq first ) |
      ( last_name.eq  last  ) |
      ( email.in_any  args  ) |
      ( login.in_any  args  )
    }

    results.concat(MIT::LDAP.build_users(search)) if results.empty? || options[:use_ldap]
    results.uniq { |user| user.login }
  end

  def name
    "#{first_name} #{last_name}"
  end

  def has_role?(title)
    title = title.to_s.titleize if title.is_a?(Symbol)
    roles.collect { |role| role.title }.include?(title)
  end
end
