require 'spec_helper'

describe User do
  it { should have_many(:receipts) }
  it { should have_many(:deliveries) }
  it { should have_many(:user_roles) }
  it { should have_one(:forwarding_address) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:login).case_insensitive }

  it 'does not require password if :forwarding_account is true' do
    expect { create(:user, :forwarding_account) }.not_to raise_error
    expect { create(:user, password: nil, password_confirmation: nil) }.to raise_error ActiveRecord::RecordInvalid
  end

  describe ".search" do
    it "finds based on first_name and last_name concatenation" do
      user = create(:user, first_name: 'bob', last_name: 'chafe')

      User.search('bob chafe').should include user
      User.search('bob ch').should include user

      User.search('bo hafe').should be_empty
    end

    it "can find users based on full or partial login" do
      user = create(:user, login: 'mrhalp')

      User.search('mrhalp').should include user
      User.search('mrh').should include user

      User.search('halp').should be_empty
    end

    it "can find users based on full or partial email" do
      user = create(:user, email: 'mrhalp@mit.edu')

      User.search('mrhalp@mit.edu').should include user
      User.search('mrhalp@').should include user

      User.search('edu').should be_empty
    end

    it "matches based on full or partial last name if it does not match by full name" do
      user = create(:user, first_name: 'Robert', last_name: 'Chafe')

      User.search('bob chafe').should include user
      User.search('chaf').should include user

      User.search('hafe').should be_empty
    end
  end

  describe ".directory_search" do
    it "instantiates new users from ldap results" do
      stub_ldap!
      users = User.directory_search('micro helpline')

      users.should_not be_empty # Ensures stubbing worked correctly

      user = users.first

      user.first_name.should eq 'Micro'
      user.last_name.should eq 'Helpline'
      user.email.should eq 'mrhalp@mit.edu'
    end

    it "filters out results missing required attributes" do
      required_attributes = %w( givenName sn mail )

      required_attributes.each do |attribute|
        stub_ldap!(attribute.to_sym => '')

        users = User.directory_search('micro helpline')

        users.should be_empty
      end
    end
  end

  describe "#assign_password" do
    it "assigns a randomly generated password and password confirmation" do
      user = build(:user, password: nil, password_confirmation: nil)

      user.assign_password

      user.password.should be_present
      user.password_confirmation.should be_present

      user.password.should eq user.password_confirmation
    end
  end
end
