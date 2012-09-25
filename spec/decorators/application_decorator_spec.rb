require 'spec_helper'

describe ApplicationDecorator do
  before { ApplicationController.new.set_current_view_context }

  class TestModel
    def created_at
      Time.zone.local(2010, 10, 30, 10, 30)
    end
  end

  class TestWorker
    def email
      'clever-name@email.org'
    end

    def name
      'Jon Snow'
    end
  end

  class TestDecorator < ApplicationDecorator
  end

  let(:model) { TestModel.new }
  let(:decorator) { TestDecorator.new(model) }

  describe "#created_at" do
    it "prettifies the #created_at attribute" do
      decorator.created_at.should eq 'October 30, 2010 at 10:30 AM'
    end
  end
end
