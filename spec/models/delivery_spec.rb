require 'spec_helper'

describe Delivery do

  it { should belong_to(:user) }
  it { should have_many(:receipts).dependent(:delete_all) }
  it { should have_many(:recipients).through(:receipts) }

  it { should validate_presence_of(:deliverer) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:receipts) }

  it { should accept_nested_attributes_for(:receipts) }

  it "sets #delivered_on to date of #created_at" do
    delivery = create(:delivery)
    delivery.delivered_on.should eq delivery.created_at.to_date
  end

  it "confirms all users" do
    delivery = build(:delivery)
    user     = create(:unapproved_user)
    receipt  = attributes_for(:receipt, user_id: user.id)

    delivery.receipts_attributes = [receipt]

    delivery.save!

    user.reload.should be_confirmed
  end

  describe "#package_count" do
    it "counts all packages across receipts" do
      receipts = build_list(:receipt, 3, number_packages: 3)
      delivery = create(:delivery, receipts: receipts)

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
