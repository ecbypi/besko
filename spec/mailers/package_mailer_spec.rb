require "spec_helper"

describe PackageMailer do

  describe "#deliver_receipt" do
    let(:receipt) { FactoryGirl.create(:receipt) }
    let(:mail) { PackageMailer.deliver_receipt(receipt) }

    it "is sent to the recipient of the receipt" do
      mail.should be_delivered_to receipt.recipient.email
    end

    it "is from the desk worker who created the delivery" do
      mail.should be_delivered_from receipt.delivery.worker.email
    end

    it "has a simple easy to understand subject" do
      mail.should have_subject /Delivery at Besk/
    end

    it "indicates the number of packages" do
      mail.should have_body_text receipt.number_packages.to_s
    end

    it "has the receipt comment" do
      mail.should have_body_text receipt.comment
    end

    it "has the deliverer" do
      mail.should have_body_text receipt.delivery.deliverer
    end

    it "has the timeestamp for the delivery" do
      mail.should have_body_text receipt.delivery.created_at.strftime('%B %d, %Y at %r')
    end

    it "has a link to view recipient's receipts" do
      mail.should have_body_text receipts_url
    end
  end
end
