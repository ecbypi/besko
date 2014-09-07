module CommandStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    allow_any_instance_of(DirectorySearch).to receive_messages(command_output: ERB.new(template).result(binding))
  end

  def stub_pts_membership_command!(*members)
    output = <<-TEMPLATE
Members of system:group (id: -00000) are:
  #{members.join("\n  ")}
    TEMPLATE

    allow_any_instance_of(PtsMembershipCommand).to receive_messages(command_output: output)
  end
end
