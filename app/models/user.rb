class User < ActiveRecord::Base
  acts_as_authentic

  has_many :received_packages, :class_name => 'Package', :foreign_key => :recipient_id
  has_many :mailed_packages, :class_name => 'Package', :foreign_key => :worker_id
  has_and_belongs_to_many :roles

  def self.find_by_email_or_login(field)
    find_by_email(field) || find_by_login(field)
  end

  def self.find_with_ldap(query, filters=[:uid, :mail, :cn, :givenName, :sn], options={})
    users = []
    default_options = {
      :request => ["mail", "uid", "givenName", "sn", "street"],
      :limit => 10,
      :exact_search => false
    }
    options = default_options.merge(options)
    query = LDAPSEARCH.query(query, filters, options)
    query.each do |result|
      users << User.new(:first_name => result["givenName"], :last_name => result["sn"], :email => result["mail"], :address => result["street"])
    end
    users
  end

  def name
    "#{first_name} #{last_name}"
  end

  def has_role?(title)
    if title.is_a? Symbol
      title = title.to_s.titleize
    end

    roles.collect { |role| role.title }.include?(title)
  end
end
