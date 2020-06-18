require 'spec_helper'

RSpec.describe User do
  it { should have_many(:receipts) }
  it { should have_many(:deliveries) }
  it { should have_many(:user_roles) }

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

      expect(User.search('bob chafe')).to include user
      expect(User.search('bob ch')).to include user

      expect(User.search('ob hafe')).to be_empty
    end

    it "can find users based on full or partial login" do
      user = create(:user, login: 'mrhalp')

      expect(User.search('mrhalp')).to include user
      expect(User.search('mrh')).to include user

      expect(User.search('halp')).to be_empty
    end

    it "can find users based on full or partial email" do
      user = create(:user, email: 'mrhalp@mit.edu')

      expect(User.search('mrhalp@mit.edu')).to include user
      expect(User.search('mrhalp@')).to include user

      expect(User.search('edu')).to be_empty
    end

    it "matches based on full or partial last name if it does not match by full name" do
      user = create(:user, first_name: 'Robert', last_name: 'Chafe')

      expect(User.search('bob chafe')).to include user
      expect(User.search('chaf')).to include user

      expect(User.search('hafe')).to be_empty
    end
  end

  describe ".directory_search" do
    it "instantiates new users from ldap results" do
      stub_ldap!
      users = User.directory_search('micro helpline')

      expect(users).not_to be_empty # Ensures stubbing worked correctly

      user = users.first

      expect(user.first_name).to eq 'Micro'
      expect(user.last_name).to eq 'Helpline'
      expect(user.email).to eq 'mrhalp@mit.edu'
    end

    it "filters out results missing required attributes" do
      required_attributes = %w( givenName sn mail )

      required_attributes.each do |attribute|
        stub_ldap!(attribute.to_sym => '')

        users = User.directory_search('micro helpline')

        expect(users).to be_empty
      end
    end
  end

  describe "#assign_password" do
    it "assigns a randomly generated password and password confirmation" do
      user = build(:user, password: nil, password_confirmation: nil)

      user.assign_password

      expect(user.password).to be_present
      expect(user.password_confirmation).to be_present

      expect(user.password).to eq user.password_confirmation
    end
  end
end
