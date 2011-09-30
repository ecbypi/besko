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
    page.should have_table('packageList', :rows => to_table([package]))
  end

  it "allows a user to sign out their packages", :js => true do
    login(user)
    visit packages_path
    click_button "Sign Out"
    page.should have_xpath('//*', :text => /Signed out on (?:\d{2,4}-?){3} at (?:\d{2}:?){3} [APM]{2}/)
    page.should have_content("Signed out package")
  end
end
