require 'spec_helper'

describe PackageDecorator do
  before { ApplicationController.new.set_current_view_context }

  let(:worker) { FactoryGirl.create(:user, first_name: 'Besk', last_name: 'Worker', email: 'besker@mit.edu') }
  let(:recipient) { FactoryGirl.create(:user, first_name: 'Micro', last_name: 'Helpline', email: 'mrhalp@mit.edu') }
  let(:package) do
    FactoryGirl.create(:package,
                       created_at: Time.zone.local(2010, 10, 30, 12, 0, 0),
                       worker: worker,
                       recipient: recipient,
                       delivered_by: 'UPS',
                       comment: 'Looks expensive'
                      )
  end

  let(:decorator) { PackageDecorator.new(package) }

  describe "#received_at" do
    it "formats #created_at into something pretty" do
      decorator.received_at.should eq 'October 30, 2010 at 12:00 PM'
    end
  end

  describe "#mail_to_worker" do
    it "creates mailto anchor to worker who received the package" do
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
    it "displays button to signout package if not signed out already" do
      decorator.sign_out_button.should match 'Sign Out'
    end

    it "displays signout timestamp if signed out" do
      time = Time.zone.local(2011, 12, 25, 13, 30, 30)
      Timecop.freeze(time) do
        package.sign_out!
        decorator.sign_out_button.should match 'December 25, 2011 at  1:30 PM'
      end
    end
  end
end
