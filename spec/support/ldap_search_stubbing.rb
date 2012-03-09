module LDAPSearchStubbing

  def ldap_result attributes={}
    attributes.reverse_merge! FactoryGirl.attributes_for(:mrhalp)
    name = [attributes[:first_name], attributes[:last_name]].join(' ')
    MIT::LDAP::Search::InetOrgPerson.new(
      givenName: attributes[:first_name],
      sn: attributes[:last_name],
      uid: attributes[:login],
      mail: attributes[:email],
      cn: name
    )
  end

  def stub_mit_ldap_search_results attributes={}
    result = ldap_result attributes
    MIT::LDAP::Search.stub(:search).and_return([result])
    result
  end
end
