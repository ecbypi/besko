require 'spec_helper'

describe "WorkerPackages", :js => true do
  let(:worker) { Factory(:besk_worker) }

  it "allows workers to view packages mailed on the current date", :js => false do
    package = Factory(:package, :received_on => Time.zone.now.to_date)
    login(worker)
    visit worker_packages_path
    page.should have_table('packageList', :rows => to_table([package], true))
    page.should have_selector('tr.package', :count => 1)
  end

  describe "allows workers to search packages via date received on by" do
    it "picking a date" do
      time = Time.zone.local(2010, 11, 12, 12, 30, 30)
      package = Factory(:package, :received_on => time.to_date, :created_at => time)
      login(worker)
      visit worker_packages_path
      page.should_not have_selector('tr.package')
      select "2010", :from => "search_received_on_equals_1i"
      select "November", :from => "search_received_on_equals_2i"
      select "12", :from => "search_received_on_equals_3i"
      click_button "Go"
      page.should have_table('packageList', :rows => to_table([package], true))
      page.should have_selector('tr.package', :count => 1)
    end

    it "navigating to the previous day" do
      packages = worker.mailed_packages + worker.received_packages
      login(worker)
      visit worker_packages_path
      page.should_not have_selector('tr.package')
      click_button "Previous Day"
      page.should have_table('packageList', :rows => to_table(packages, true))
      page.should have_selector('tr.package', :count => packages.size)
    end

    it "navigating to the next day" do
      time = Time.zone.now.to_date + 1.day
      package = Factory(:package, :received_on => time.to_date, :created_at => time)
      login(worker)
      visit worker_packages_path
      click_button "Next Day"
      page.should have_table('packageList', :rows => to_table([package], true))
      page.should have_selector('tr.package', :count => 1)
    end
  end

  describe "allows workers to search packages by the recipient's" do
    let!(:recipient) { Factory(:approved_user, :first_name => 'Bob', :last_name => 'Anderson', :email => 'unique@MIT.EDU') }
    let!(:package) { Factory(:base_package, :recipient => recipient, :worker => Factory(:approved_user)) }
    it "email" do
      login(worker)
      visit worker_packages_path
      choose "Search by Recipient Name or Email"
      fill_in "Name or Email", :with => recipient.email
      click_button "Search"
      page.should have_table('packageList', :rows => to_table([package], true))
      page.should have_selector('tr.package', :count => 1)
    end
  end
end
