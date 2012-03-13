require 'spec_helper'

describe User do
  let(:user) { Factory(:user) }

  it { should have_many(:receipts) }
  it { should have_many(:deliveries) }
  it { should have_and_belong_to_many(:roles) }


  describe "#name" do
    it "joins first and last names" do
      user.name.should eq("First Last Name")
    end
  end

  describe "#has_role?" do
    it "returns true if user's roles include the provided attribute" do
      user = Factory(:user)
      role = Factory(:role, title: 'Besk Worker')
      user.roles << role
      user.has_role?(:besk_worker).should be(true)
    end

    it "returns false if user does not have that role" do
      user.has_role?(:besk_worker).should be(false)
    end
  end

  describe ".recipients" do
    let!(:result) { FactoryGirl.create(:mrhalp) }

    it "searches for applicants based on search string containing the name" do
      User.recipients('micro helpline').should include result
    end

    it "returns empty array if arguments are empty" do
      User.recipients('').should eq []
    end

    it "can find applicants based on login" do
      User.recipients('mrhalp').should include result
    end

    it "can find applicants based on email" do
      User.recipients('mrhalp@mit.edu').should include result
    end

    it "checks ldap server if :use_ldap is true" do
      stub_mit_ldap_search_results
      User.recipients('micro helpline', use_ldap: true)
    end

    it "checks ldap server if no records are found in the database" do
      stub_mit_ldap_search_results
      User.recipients('mshalp')
    end

    it "returns uniq results if it checks the ldap server" do
      stub_mit_ldap_search_results
      User.recipients('micro helpline', use_ldap: true).should eq [result]
    end
  end

  describe ".create_without_or_without_password" do
    let(:attributes) { FactoryGirl.attributes_for(:user) }
    it "creates the user password parameters are provided" do
      user = User.create_with_or_without_password(attributes)
      user.valid_password?('password').should eq true
    end

    it "autogenerates password if the details are missing " do
      attributes.delete(:password) and attributes.delete(:password_confirmation)
      user = User.create_with_or_without_password(attributes)
      user.should be_persisted
    end
  end
end
