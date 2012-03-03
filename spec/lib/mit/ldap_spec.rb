require 'spec_helper'

describe MIT::LDAP do
  describe "it includes Ldaptic::Module" do
    it { should respond_to :search }
    it { should respond_to :find }
  end

  describe ".build_users" do
    it "returns unpersisted instances of User model" do
      stub_mit_ldap_search_results
      users = MIT::LDAP.build_users('micro helpline')
      users.size.should eq 1
      user = users.first
      user.should be_a ::User
      user.first_name.should eq 'Micro'
      user.last_name.should eq 'Helpline'
      user.login.should eq 'mrhalp'
      user.email.should eq 'mrhalp@mit.edu'
    end
  end
end
