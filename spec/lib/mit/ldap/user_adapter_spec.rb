require 'spec_helper'

module MIT
  module LDAP
    describe UserAdapter do

      subject { MIT::LDAP::UserAdapter }

      describe ".build_users" do
        it "returns empty array if not connected" do
          MIT::LDAP.stub(:connected?).and_return(false)
          subject.build_users('micro helpline').should be_empty
        end

        it "returns unpersisted instances of User model" do
          stub_mit_ldap_search_results
          user = subject.build_users('micro helpline').first
          user.should be_a ::User
          user.first_name.should eq 'Micro'
          user.last_name.should eq 'Helpline'
          user.login.should eq 'mrhalp'
          user.email.should eq 'mrhalp@mit.edu'
          user.street.should eq 'N42'
        end

        describe "filters out bad results" do
          before :each do
            MIT::LDAP.stub(:connected?).and_return(true)
          end

          it "that aren't InetOrgPerson" do
            MIT::LDAP.stub(:search).and_return([ldap_result, {}])
            results = subject.build_users('micro helpline')
            results.size.should eq 1
          end

          it "that are missing attributes" do
            invalid = ldap_result(first_name: nil, last_name: nil, login: nil)
            MIT::LDAP.stub(:search).and_return([invalid, ldap_result])
            results = subject.build_users('micro helpline')
            results.size.should eq 1
          end
        end
      end

      describe "#construct_filter" do
        let(:filter) { subject.construct_filter('micro helpline').to_s }

        it "builds key for :cn (common name)" do
          filter.should match 'cn='
        end

        it "builds search for :givenName and :sn" do
          filter.should match 'givenName='
          filter.should match 'sn='
        end

        it "doesn't choke on one word string" do
          expect { subject.construct_filter('mrhalp') }.not_to raise_error
        end
      end
    end
  end
end
