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
      end
    end
  end
end
