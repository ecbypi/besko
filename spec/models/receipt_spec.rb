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

      expect(receipt.signed_out?).to eq(false)
    end

    it "is true when signed out" do
      receipt = create(:receipt, signed_out_at: Time.zone.now)

      expect(receipt.signed_out?).to eq(true)
    end
  end
end
