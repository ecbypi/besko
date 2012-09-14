require 'spec_helper'

describe Delivery do

  it { should belong_to(:worker) }
  it { should have_many(:receipts) }
  it { should have_many(:recipients).through(:receipts) }

  it { should validate_presence_of(:deliverer) }
  it { should validate_presence_of(:worker_id) }

  it "accepts nested attributes for receipts" do
    expect { Delivery.new(receipts_attributes: []) }.not_to raise_error ActiveRecord::UnknownAttributeError
  end

  it "sets #delivered_on to date of #created_at" do
    delivery = create(:delivery)
    delivery.delivered_on.should eq delivery.created_at.to_date
  end

  it "confirms all users" do
    delivery = build(:delivery)
    user     = create(:unapproved_user)
    receipt  = attributes_for(:receipt, recipient_id: user.id)

    delivery.receipts_attributes = [receipt]

    delivery.save!

    user.reload.should be_confirmed
  end

  describe "#package_count" do
    let(:delivery) { create(:delivery) }
    let(:receipts) { create_list(:receipt, 3, number_packages: 3) }
    it "counts all packages across receipts" do
      delivery.receipts << receipts
      delivery.package_count.should eq 9
    end
  end

  describe ".delivered_on" do
    before :each do
      Delivery.delete_all
    end

    let(:todays_delivery) { create(:delivery) }
    let(:old_delivery) { create(:delivery, delivered_on: '2010-10-30', created_at: '2010-10-30') }

    it "defaults to today's deliveries" do
      Delivery.delivered_on.should include todays_delivery
      Delivery.delivered_on.should_not include old_delivery
    end

    it "finds packages on the supplied date otherwise" do
      Delivery.delivered_on('2010-10-30').should include old_delivery
      Delivery.delivered_on('2010-10-30').should_not include todays_delivery
    end
  end
end
