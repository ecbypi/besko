require 'spec_helper'

describe ApplicationDecorator do
  class TestModel
    def something_at
      Time.zone.local(2010, 10, 30, 10, 30)
    end
  end

  class TestDecorator < ApplicationDecorator
  end

  let(:model) { TestModel.new }
  let(:decorator) { TestDecorator.new(model) }

  describe "#format_timestamp" do
    it "prettifies the supplied attribute" do
      expect(decorator.format_timestamp(:something_at)).to eq '10:30 AM on Oct 30, 2010'
    end
  end
end
