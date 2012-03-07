require 'spec_helper'

describe DeliveriesHelper do

  let(:time) { Date.new(2010,10,30) }

  let(:attribute) do
    attribute = mock 'attribute'
    value = mock 'value'
    value.stub(:value).and_return(time.to_s)
    attribute.stub(:values).and_return([value])
    attribute
  end

  describe "#delivery_date" do
    it "returns the current date if no search has been performed" do
      helper.delivery_date(nil).should eq Date.today
    end

    it "returns date from the search if one has been performed" do
      helper.delivery_date(attribute).should eq time
    end
  end

  describe "#previous_delivery_date" do
    it "returns the day from the search minus one day" do
      helper.previous_delivery_date(attribute).should eq time - 1.day
    end
  end

  describe "#next_delivery_date" do
    it "returns the day from the search plus one day" do
      helper.next_delivery_date(attribute).should eq time + 1.day
    end
  end
end
