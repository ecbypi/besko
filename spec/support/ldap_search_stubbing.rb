module LDAPSearchStubbing
  def stub_ldap_server_configuration!
    DirectorySearch.stub(server: 'server.edu')
  end

  def stub_empty_ldap_server_configuration!
    DirectorySearch.stub(server: nil)
  end

  def stub_ldap!(attributes = {})
    stub_ldap_server_configuration!

    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    DirectorySearch.any_instance.stub(command_output: ERB.new(template).result(binding))
  end
end
