module LDAPSearchStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    DirectorySearch.any_instance.stub(command_output: ERB.new(template).result(binding))
  end
end
