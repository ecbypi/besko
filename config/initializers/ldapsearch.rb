LDAPSEARCH.configure do |config|
  config.host = 'ldap.mit.edu'
  config.search_base = 'dc=mit,dc=edu'
end
