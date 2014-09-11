module CommandStubbing
  def stub_ldap!(attributes = {})
    attributes.reverse_merge!(attributes_for(:ldap_entry))

    template = File.read(Rails.root.join('spec/fixtures/ldapsearch.erb'))
    command = double('command', run: ERB.new(template).result(binding))

    allow_any_instance_of(DirectorySearch).to receive_messages(command: command)
  end

  def stub_pts_membership_command!(*members)
    output = <<-TEMPLATE
Members of system:group (id: -00000) are:
  #{members.join("\n  ")}
    TEMPLATE

    command = double('command', run: output)

    allow_any_instance_of(PtsMembershipCommand).to receive_messages(command: command)
  end
end