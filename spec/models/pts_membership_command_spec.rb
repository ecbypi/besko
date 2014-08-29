require "spec_helper"

RSpec.describe PtsMembershipCommand do
  it "looks up members of an afs group" do
    stub_pts_membership_command! "thechief", "drhalp", "mshalp"

    pts_command = PtsMembershipCommand.new("fakelist")

    expect(pts_command.group_members).to eq %w( thechief drhalp mshalp )
  end

  it "handles false positive exit commands" do
    allow_any_instance_of(PtsMembershipCommand).to receive_messages(command_output: "Not an expected output")

    pts_command = PtsMembershipCommand.new("fakelist")

    expect(pts_command.group_members).to eq []
    expect(pts_command).not_to be_successful
  end
end
