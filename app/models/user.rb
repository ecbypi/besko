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

  def self.lookup(search = nil, options = nil)
    results = []
    options ||= {}

    return results if search.blank?

    if !options[:remote_only]
      terms = search.split
      likened_terms = terms.map { |term| "%#{term}%" }

      local_results = where do
        ( concat(first_name, ' ', last_name).like "%#{terms.join('% %')}%" ) |
        ( last_name.like  "%#{terms.last}%"  ) |
        ( email.like_any  likened_terms      ) |
        ( login.like_any  likened_terms      )
      end

      results.concat(local_results)
    end

    if !options[:local_only]
      remote_results = MIT::LDAP::UserAdapter.build_users(search)
      results.concat(remote_results)
    end

    if results.empty? || ( local_results.empty? && remote_results.size > 10 )
      first_name, last_name = search.split(' ', 2).map { |piece| piece.titleize }
      result = User.new(first_name: first_name, last_name: last_name, email: 'besker-super@mit.edu')
      results.push(result)
    end

    results.to_a.uniq { |user| user.email }
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
