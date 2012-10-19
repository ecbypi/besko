require 'spec_helper'

describe User do
  let!(:user) { create(:user) }

  it { should have_many(:receipts) }
  it { should have_many(:deliveries) }
  it { should have_many(:user_roles) }

  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:login).case_insensitive }

  it "sends confirmation instructions to besko@mit.edu" do
    headers = user.headers_for(:confirmation_instructions)
    headers[:to].should eq 'besko@mit.edu'
  end

  describe "#name" do
    it "joins first and last names" do
      user.name.should eq("First Last Name")
    end
  end

  describe ".lookup" do
    let!(:result) { create(:mrhalp) }

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

    it "matches based on last name if it does not match by full name" do
      chief = create(:user, first_name: 'Robert', last_name: 'Chafe')

      User.lookup('bob chafe').should eq [chief]
    end

    it "does not check ldap if :local_only is true" do
      MIT::LDAP.should_receive(:search).exactly(0).times
      User.lookup('micro helpline', local_only: true)
    end

    it "only checks ldap server is :remote_only is true" do
      User.should_receive(:where).exactly(0).times
      User.lookup('micro helpline', remote_only: true)
    end

    it "returns uniq results if it checks the ldap server" do
      stub_mit_ldap_search_results

      User.lookup('micro helpline').should eq [result]
    end

    it "builds a user with the besker-super email address if nothing is found" do
      user = User.lookup('mike roe').first

      user.first_name.should eq 'Mike'
      user.last_name.should eq 'Roe'
      user.email.should eq 'besker-super@mit.edu'
    end
  end

  describe ".assign_password" do
    let(:user) { build(:user) }

    it "assigns a randomly generated password and password confirmation" do
      User.assign_password(user)

      user.password.should be_present
      user.password_confirmation.should be_present

      user.password.should eq user.password_confirmation
    end

    it "accepts user attributes" do
      user = User.assign_password(attributes_for(:user))

      user.password.should be_present
      user.password_confirmation.should be_present

      user.password.should eq user.password_confirmation
    end
  end

  describe "#skip_confirmation_email!" do
    let(:user) { build(:user) }
    it "allows skipping confirmation email, but leaves user in a state requiring confirmation" do
      user.skip_confirmation_email!
      user.save!

      last_email.should be_nil
    end
  end
end
