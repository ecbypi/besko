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
  has_guises :BeskWorker, :Admin, :association => :user_roles

  validates :first_name, :last_name, :login, presence: true
  validates :login, uniqueness: true

  attr_accessible :first_name,
                  :last_name,
                  :login,
                  :email,
                  :street,
                  :password,
                  :password_confirmation


  def self.lookup(search = nil, options = nil)
    results = []
    options ||= {}

    return results if search.blank?

    if !options[:remote_only]
      terms = search.split

      local = where do
        ( concat(first_name, ' ', last_name).like "%#{terms.join('% %')}%" ) |
        ( email.like_any terms ) |
        ( login.like_any terms )
      end

      results.concat(local)
    end

    if !options[:local_only]
      results.concat MIT::LDAP::UserAdapter.build_users(search)
    end

    results.to_a.uniq { |user| user.login }
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
end
