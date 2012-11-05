step "the following user exists in the LDAP server:" do |table|
  stub_ldap!(table.hashes.first)
end

step "mrhalp exists in the LDAP server" do
  stub_ldap! # stubs with mrhalp attributes by default
end
