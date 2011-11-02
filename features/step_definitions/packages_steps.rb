Given /^I am logged in$/ do
  visit login_path
  fill_in "Login", :with => @user.email
  fill_in "Password", :with => @user.password
  click_button "Login"
end

Then /^I should see a table with all my packages$/ do
  rows = @packages.collect do |package|
    [
      package.worker.name,
      package.received_at,
      package.delivered_by,
      package.comment
    ]
  end
  page.should have_table('packages', :rows => rows)
end

When /^I click the 'Sign Out' button for one of the packages$/ do
  @time = Time.zone.now
  within "table#packages" do
    click_button "Sign Out"
  end
end

Then /^the time the package was signed out at replaces the 'Sign Out' button$/ do
  within "table#packages" do
    page.should have_content(@time.strftime("%Y-%m-%d at %r"))
  end
end
