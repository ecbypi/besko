require "spec_helper"

describe Mailer do
  describe "#package_confirmation" do
    it 'is from the desk worker, to the recipient of the package containing receipt information' do
      recipient = create(
        :user,
        first_name: 'Frank',
        last_name: 'Underwood',
        email: 'frank@whitehouse.gov'
      )

      worker = create(
        :user,
        first_name: 'Remy',
        last_name: 'Danton',
        email: 'remy@whitehouse.gov'
      )

      delivery = create(
        :delivery,
        user: worker,
        deliverer: 'FedEx',
        created_at: Time.zone.local(2010, 10, 30, 10)
      )

      receipt = create(
        :receipt,
        number_packages: 3,
        delivery: delivery,
        user: recipient,
        comment: 'Big and heavy'
      )

      mail = Mailer.package_confirmation(receipt.id)

      mail.should be_delivered_to 'frank@whitehouse.gov'
      mail.should be_delivered_from 'Remy Danton <remy@whitehouse.gov>'
      mail.should have_subject '[Besko] Delivery from FedEx at the front desk'

      mail.should have_body_text 'Frank Underwood'
      mail.should have_body_text 'Remy Danton (remy@whitehouse.gov)'
      mail.should have_body_text 'Delivered By: FedEx'
      mail.should have_body_text 'Number of Packages: 3'
      mail.should have_body_text 'Delivered At: October 30, 2010 at 10:00:00 AM'
      mail.should have_body_text "Comment:\nBig and heavy"
      mail.should have_body_text receipts_url
    end
  end
end
