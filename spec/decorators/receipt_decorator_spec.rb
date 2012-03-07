require 'spec_helper'

describe ReceiptDecorator do
  before { ApplicationController.new.set_current_view_context }

  let(:worker) { FactoryGirl.create(:user, first_name: 'Besk', last_name: 'Worker', email: 'besker@mit.edu') }
  let(:recipient) { FactoryGirl.create(:user, first_name: 'Micro', last_name: 'Helpline', email: 'mrhalp@mit.edu') }
  let(:delivery) { FactoryGirl.create(:delivery, deliverer: 'UPS', worker: worker) }
  let(:receipt) do
    FactoryGirl.create(:receipt,
                       created_at: Time.zone.local(2010, 10, 30, 12, 0, 0),
                       recipient: recipient,
                       comment: 'Looks expensive',
                       delivery: delivery
                      )
  end

  let(:decorator) { ReceiptDecorator.new(receipt) }

  describe "#delivered_by" do
    it "proxies to delivery.deliverer" do
      decorator.delivered_by.should eq delivery.deliverer
    end
  end

  describe "#received_at" do
    it "formats #created_at into something pretty" do
      decorator.received_at.should eq 'October 30, 2010 at 12:00 PM'
    end
  end

  describe "#mail_to_worker" do
    it "creates mailto anchor to worker who received the packages" do
      decorator.mail_to_worker.should match 'Besk Worker'
      decorator.mail_to_worker.should match 'mailto:besker@mit.edu'
    end
  end

  describe "#recipient_name" do
    it "proxies recipient's name" do
      recipient.should_receive(:name)
      decorator.recipient_name
    end
  end

  describe "#sign_out_button" do
    it "displays button to signout packages if not signed out already" do
      decorator.sign_out_button.should match 'Sign Out'
    end

    it "displays signout timestamp if signed out" do
      time = Time.zone.local(2011, 12, 25, 13, 30, 30)
      Timecop.freeze(time) do
        receipt.sign_out!
        decorator.sign_out_button.should match 'December 25, 2011 at  1:30 PM'
      end
    end
  end
end