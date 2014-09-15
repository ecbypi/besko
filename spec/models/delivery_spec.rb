require 'spec_helper'

RSpec.describe Delivery do

  it { should belong_to(:user) }
  it { should have_many(:receipts).dependent(:delete_all) }
  it { should have_many(:recipients).through(:receipts) }

  it { should validate_presence_of(:deliverer) }
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:receipts) }

  it { should accept_nested_attributes_for(:receipts) }

  it "sets #delivered_on on creation" do
    delivery = create(:delivery)
    expect(delivery.delivered_on).not_to be_nil
  end

  it "activates and confirms all users logged in a delivery" do
    delivery = build(:delivery)
    user     = create(:user, :unconfirmed)
    receipt  = attributes_for(:receipt, user_id: user.id)

    delivery.receipts_attributes = [receipt]

    delivery.save!
    user.reload

    expect(user).to be_confirmed
    expect(user).to be_activated
  end

  describe "#package_count" do
    it "counts all packages across receipts" do
      receipts = build_list(:receipt, 3, number_packages: 3)
      delivery = create(:delivery, receipts: receipts)

      expect(delivery.package_count).to eq 9
    end
  end
end
