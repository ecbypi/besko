require 'spec_helper'

describe "Packages" do
  let!(:user) { Factory(:user) }
  let!(:package) { user.received_packages.first }
  let!(:worker) { package.worker }

  before(:each) do
    activate_authlogic
  end

  it "allows a user to view their packages" do
    login(user)
    visit packages_path
    page.should have_selector("tr.packageRow.package#{package.id}")
    within("tr.packageRow.package#{package.id}") do
      page.should have_link(worker.name, :href => "mailto:#{worker.email}")
      page.should have_content(package.received_at)
      page.should have_content(package.delivered_by)
      page.should have_content(package.comment)
      page.should have_button("Sign Out")
    end
  end

  it "allows a user to sign out their packages", :js => true do
    login(user)
    visit packages_path
    click_button "Sign Out"
    page.should have_xpath('//*', :text => /Signed out on (?:\d{2,4}-?){3} at (?:\d{2}:?){3} PM/)
    page.should have_content("Signed out package")
  end
end
