step "the following user exists in the LDAP server:" do |table|
  stub_mit_ldap_search_results(table.hashes.first)
end

step "mrhalp exists in the LDAP server" do
  attributes = attributes_for(:mrhalp)
  stub_mit_ldap_search_results(attributes)
end
