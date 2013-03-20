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
end
