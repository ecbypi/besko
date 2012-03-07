require 'spec_helper'

describe Receipt do

  let(:receipt) { FactoryGirl.create(:receipt) }

  it { should belong_to(:recipient) }
  it { should belong_to(:delivery) }

  describe "#sign_out!" do
    it "sets #signed_out_at to current time" do
      Timecop.freeze do
        expect { receipt.sign_out! }.to change { receipt.signed_out_at }.from(nil).to(Time.zone.now)
      end
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
