require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }

  it { should have_many(:received_packages) }
  it { should have_many(:mailed_packages) }
  it { should have_and_belong_to_many(:roles) }


  describe "#name" do
    it "joins first and last names" do
      user.name.should eq("First Last Name")
    end
  end

  describe "#has_role?" do
    it "returns true if user's roles include the provided attribute" do
      user = Factory(:besk_worker)
      user.has_role?(:besk_worker).should be(true)
    end

    it "returns false if user does not have that role" do
      user.has_role?(:besk_worker).should be(false)
    end
  end
end
