module LDAPSearchStubbing

  def stub_mit_ldap_search_results attributes={}
    attributes.reverse_merge! FactoryGirl.attributes_for(:mrhalp)
    name = [attributes[:first_name], attributes[:last_name]].join(' ')
    result = MIT::LDAP::InetOrgPerson.new(
      givenName: attributes[:first_name],
      sn: attributes[:last_name],
      uid: attributes[:login],
      mail: attributes[:email],
      cn: name
    )
    MIT::LDAP.stub(:search).and_return([result])
    MIT::LDAP.should_receive(:search).and_return([result])
    result
  end
end
