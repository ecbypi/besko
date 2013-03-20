require 'spec_helper'

describe MIT do
  describe '.on_campus?' do
    it 'is true when on campus' do
      Cocaine::CommandLine.any_instance.stub(run: File.read(Rails.root.join('spec/fixtures/ifconfig-on-campus')))

      MIT.should be_on_campus
    end

    it 'is false when off campus' do
      Cocaine::CommandLine.any_instance.stub(run: File.read(Rails.root.join('spec/fixtures/ifconfig-off-campus')))


      MIT.should be_off_campus
    end
  end
end
