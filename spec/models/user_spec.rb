require 'spec_helper'

describe User do
  let!(:user) { create(:user) }

  it { should have_many(:receipts) }
  it { should have_many(:deliveries) }
  it { should have_many(:user_roles) }
  it { should have_many(:roles).through(:user_roles) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:login) }
  it { should validate_uniqueness_of(:login) }

  it "sends confirmation instructions to besko@mit.edu" do
    headers = user.headers_for(:confirmation_instructions)
    headers[:to].should eq 'besko@mit.edu'
  end

  describe "#name" do
    it "joins first and last names" do
      user.name.should eq("First Last Name")
    end
  end

  describe "#has_role?" do
    let(:user) { create(:user) }
    let(:role) { create(:role) }

    before :each do
      double_roles :BeskWorker, :MailForwarder
      stub_user_roles(user, :besk_worker)
    end

    it "returns true if user's roles include the provided class object" do
      user.has_role?(BeskWorker).should be_true
    end

    it "accepts a symbol" do
      user.has_role?(:besk_worker).should be_true
    end

    it "accepts a string" do
      user.has_role?('besk_worker').should be_true
      user.has_role?('BeskWorker').should be_true
    end

    it "returns false if user does not have that role" do
      user.has_role?(MailForwarder).should be_false
    end

    it "raises error if class does not exist" do
      expect { user.has_role?(:shop_manager) }.to raise_error(NameError)
    end
  end

  describe ".lookup" do
    let!(:result) { create(:mrhalp) }

    before :each do
      stub_mit_ldap_search_results
    end

    it "searches for applicants based on search string containing the name" do
      User.lookup('micro helpline').should include result
    end

    it "returns empty array if arguments are empty or nil" do
      User.lookup('').should eq []
      User.lookup.should eq []
    end

    it "can find applicants based on login" do
      User.lookup('mrhalp').should include result
    end

    it "can find applicants based on email" do
      User.lookup('mrhalp@mit.edu').should include result
    end

    it "does not check ldap if :skip_ldap_search is true" do
      MIT::LDAP::Search.should_receive(:search).exactly(0).times
      User.lookup('micro helpline', skip_ldap_search: true)
    end

    it "only checks ldap server is :ldap_search_only is true" do
      User.should_receive(:where).exactly(0).times
      User.lookup('micro helpline', ldap_search_only: true)
    end

    it "checks ldap server if no records are found in the database" do
      User.lookup('mshalp')
    end

    it "returns uniq results if it checks the ldap server" do
      User.lookup('micro helpline', use_ldap: true).should eq [result]
    end
  end

  describe ".create_without_or_without_password" do
    let(:attributes) { attributes_for(:user) }
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
