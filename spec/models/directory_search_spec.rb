require 'spec_helper'

describe DirectorySearch do
  before do
    stub_ldap_server_configuration!
  end

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

      search.search
      search.search
    end

    it 'does not search if LDAP_SERVER is not configured' do
      stub_empty_ldap_server_configuration!

      search = DirectorySearch.new('mrhalp')

      search.search.should eq []
    end
  end
end
