require 'spec_helper'

RSpec.describe DirectorySearch do
  it 'handles unexpected outcodes' do
    expect_any_instance_of(Cocaine::CommandLine).to receive(:run).and_raise(Cocaine::ExitStatusError)

    expect(DirectorySearch.search('mrhalp')).to eq []
  end

  it 'times out after 2 seconds' do
    Timeout.timeout(3) do
      allow_any_instance_of(Cocaine::CommandLine).to receive(:run) { sleep 120 }

      expect(DirectorySearch.search('mrhalp')).to eq []
    end
  end

  describe 'search' do
    it 'is idempotent per instance' do
      stub_ldap!

      expect_any_instance_of(DirectorySearch).to receive(:command_output).
        exactly(:once).
        and_call_original

      search = DirectorySearch.new('mrhalp')

      search.results
      search.results
    end

    it 'does not search if LDAP_SERVER is not configured' do
      ldap_server = ENV.delete('LDAP_SERVER')

      search = DirectorySearch.search('mrhalp')

      expect(search).to eq []

      ENV['LDAP_SERVER'] = ldap_server
    end
  end
end
