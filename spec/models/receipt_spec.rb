require 'spec_helper'

describe Receipt do

  it { should belong_to(:user) }
  it { should belong_to(:delivery) }
  it { should have_one(:worker).through(:delivery) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:delivery) }
  it { should validate_numericality_of(:number_packages) }

  describe "#signed_out?" do
    it "is false when receipt's packages is not signed out" do
      receipt = create(:receipt)

      receipt.signed_out?.should eq(false)
    end

    it "is true when signed out" do
      receipt = create(:receipt, signed_out_at: Time.zone.now)

      receipt.signed_out?.should eq(true)
    end
  end
end
