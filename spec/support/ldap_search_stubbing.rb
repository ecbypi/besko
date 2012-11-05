module MIT::LDAP
  def self.search(options = {})
    []
  end
end

module LDAPSearchStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    attributes.stringify_keys!

    MIT::LDAP.stub(:connected?).and_return(true)
    MIT::LDAP.stub(:search).and_return([attributes])
  end
end
