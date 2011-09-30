require 'spec_helper'

describe Package do

  let!(:package) { Factory(:package) }

  it { should belong_to(:recipient) }
  it { should belong_to(:worker) }

  describe "#sign_out!" do
    it "signs out the package" do
      Timecop.freeze do
        expect { package.sign_out! }.to change { package.signed_out_at }.from(nil).to(Time.zone.now)
      end
    end
  end

  describe "#signed_out?" do
    it "is false when package is not signed out" do
      package.signed_out?.should eq(false)
    end

    it "is true when package is signed out" do
      package.signed_out_at = Time.zone.now
      package.signed_out?.should eq(true)
    end
  end

  describe "#received_at" do
    it "formats created_at" do
      time = Time.zone.local(2011, 1, 1, 12, 30, 30)
      Timecop.freeze(time) do
        package = Factory(:package)
        package.received_at.should eq("2011-01-01 at 12:30:30 PM")
      end
    end
  end

  describe "#received_by" do
    it "is an alias for #worker" do
      package.received_by.should eq(package.worker)
    end
  end

  describe ".for_date" do
    let(:date) { (Time.zone.now.to_date - 5.days).to_date }
    it "returns packages released on the provided date" do
      package = Factory(:package, :received_on => date)
      Package.for_date(date).should eq([package])
    end

    it" returns packages released on the current date if date == nil" do
      package = Factory(:package, :received_on => Time.zone.now.to_date)
      Package.for_date.should eq([package])
    end
  end
end
