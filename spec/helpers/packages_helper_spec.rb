require 'spec_helper'

describe PackagesHelper do
  let(:package) { Factory(:package) }
  let(:time) { Time.zone.local(2011,1,1,12,30,30) }

  describe ".signed_out_at" do
    it "formats Package#signed_out_at into a string" do
      Timecop.freeze(time) do
        package.sign_out!
        helper.signed_out_at(package).should eq("Signed out on 2011-01-01 at 12:30:30 PM")
      end
    end
  end
end
