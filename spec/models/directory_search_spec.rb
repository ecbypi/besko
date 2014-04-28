require 'spec_helper'

describe DirectorySearch do
  it 'handles unexpected outcodes' do
    Cocaine::CommandLine.any_instance.should_receive(:run).and_raise(Cocaine::ExitStatusError)

    DirectorySearch.search('mrhalp').should eq []
  end

  it 'times out after 2 seconds' do
    Timeout.timeout(3) do
      Cocaine::CommandLine.any_instance.stub(:run) { sleep 120 }

      DirectorySearch.search('mrhalp').should eq []
    end
  end

  describe 'search' do
    it 'is idempotent per instance' do
      stub_ldap!

      DirectorySearch.any_instance.should_receive(:command_output).exactly(:once)

      search = DirectorySearch.new('mrhalp')

      search.results
      search.results
    end

    it 'does not search if LDAP_SERVER is not configured' do
      ldap_server = ENV.delete('LDAP_SERVER')

      search = DirectorySearch.search('mrhalp')

      search.should eq []

      ENV['LDAP_SERVER'] = ldap_server
    end
  end
end
