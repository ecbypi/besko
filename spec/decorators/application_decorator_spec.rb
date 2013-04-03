require 'spec_helper'

describe ApplicationDecorator do
  before { ApplicationController.new.set_current_view_context }

  class TestModel
    def something_at
      Time.zone.local(2010, 10, 30, 10, 30)
    end
  end

  class TestDecorator < ApplicationDecorator
  end

  let(:model) { TestModel.new }
  let(:decorator) { TestDecorator.new(model) }

  describe "#created_at" do
    it "prettifies the #created_at attribute" do
      decorator.format_timestamp(:something_at).should eq '10:30 AM on Oct 30, 2010'
    end
  end
end
