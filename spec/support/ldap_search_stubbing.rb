module LDAPSearchStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    allow_any_instance_of(DirectorySearch).to receive_messages(command_output: ERB.new(template).result(binding))
  end
end
