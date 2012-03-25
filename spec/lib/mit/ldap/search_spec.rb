require 'spec_helper'

module MIT
  module LDAP
    module Search
      describe InetOrgPerson do

        describe "#to_user" do
          it "converts itself into a user instance" do
            user = InetOrgPerson.new.to_user
            user.should be_instance_of ::User
            user.should be_new_record
          end
        end

        describe "#valid?" do
          it "returns false if name, email or login are missing" do
            person = InetOrgPerson.new
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
end
