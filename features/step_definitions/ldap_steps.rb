Given /^the following user exists in the LDAP server:$/ do |table|
  stub_mit_ldap_search_results(table.hashes.first)
end
