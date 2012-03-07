require 'spec_helper'

describe Delivery do

  it { should belong_to(:worker) }
  it { should have_many(:receipts) }

  it { should validate_presence_of(:deliverer) }

  describe "#package_count" do
    let(:delivery) { FactoryGirl.create(:delivery) }
    let(:receipts) { FactoryGirl.create_list(:receipt, 3, number_packages: 3) }
    it "counts all packages across receipts" do
      delivery.receipts << receipts
      delivery.package_count.should eq 9
    end
  end
end