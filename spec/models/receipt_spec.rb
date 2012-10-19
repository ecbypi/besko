require 'spec_helper'

describe Receipt do

  let!(:receipt) { create(:receipt) }

  it { should belong_to(:recipient) }
  it { should belong_to(:delivery) }

  it { should validate_presence_of(:recipient_id) }
  it { should validate_numericality_of(:number_packages) }

  it "should validate presence of delivery_id on update" do
    receipt = create(:receipt)
    receipt.delivery_id = nil
    expect { receipt.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  describe "#sign_out!" do
    it "sets #signed_out_at to current time" do
      Timecop.freeze do
        expect { receipt.sign_out! }.to change { receipt.signed_out_at }.from(nil).to(Time.zone.now)
      end
    end
  end

  describe "#worker" do
    it "proxies to delivery.worker" do
      receipt.worker.should eq receipt.delivery.worker
    end
  end

  describe "#deliverer" do
    it "proxies to delivery.deliverer" do
      receipt.deliverer.should eq receipt.delivery.deliverer
    end
  end

  describe "#signed_out?" do
    it "is false when receipt's packages is not signed out" do
      receipt.signed_out?.should eq(false)
    end

    it "is true when signed out" do
      receipt.signed_out_at = Time.zone.now
      receipt.signed_out?.should eq(true)
    end
  end
end
