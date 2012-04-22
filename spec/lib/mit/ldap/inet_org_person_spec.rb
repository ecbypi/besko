require 'spec_helper'

module MIT
  module LDAP
    describe InetOrgPerson do

      # creates a new stubbed MIT::LDAP::InetOrgPerson
      let(:person) { ldap_result }

      describe "#to_user" do
        it "converts itself into a user instance" do
          person.to_user.should be_instance_of ::User
          person.to_user.should be_new_record
        end
      end

      describe "#valid?" do
        it "returns false if name, email or login are missing" do
          person = ldap_result(
            first_name: nil,
            last_name: nil,
            email: nil,
            login: nil,
            street: nil
          )
          person.valid?.should eq false
        end

        it "returns true if name, email and login are present" do
          person = ldap_result
          person.valid?.should eq true
        end
      end
    end
  end
end
