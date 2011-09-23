require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }

  it { should have_many(:received_packages) }
  it { should have_many(:mailed_packages) }

  describe ".find_with_ldap" do
    let(:user) { User.find_with_ldap("edd_d").first }

    it "returns array of user instances" do
      user.should be_instance_of(User)
    end

    it "user instances are not persisted" do
      user.should be_new_record
    end
  end
end
