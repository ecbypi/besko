module LDAPSearchStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    Cocaine::CommandLine.any_instance.stub(run: ERB.new(template).result(binding))
  end
end
