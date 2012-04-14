module LDAPSearchStubbing

  def ldap_result attributes={}
    attributes.reverse_merge! FactoryGirl.attributes_for(:mrhalp)
    name = [attributes[:first_name], attributes[:last_name]].join(' ')
    MIT::LDAP::InetOrgPerson.new(
      givenName: attributes[:first_name],
      sn: attributes[:last_name],
      uid: attributes[:login],
      mail: attributes[:email],
      cn: name,
      street: attributes[:street]
    )
  end

  def stub_mit_ldap_search_results attributes={}
    result = ldap_result attributes
    MIT::LDAP.stub(:search).and_return([result])
    result
  end
end
