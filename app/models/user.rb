class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  validates_confirmation_of :password

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
end
