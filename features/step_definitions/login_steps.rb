Given /^I have an approved user account$/ do
  @user = Factory(:user)
end

When /^I submit my (.+) and password on the login page$/ do |credential|
  visit login_path
  fill_in "Login", :with => @user.send(credential.to_sym)
  fill_in "Password", :with => @user.password
  click_button "Login"
end

When /^I submit an incorrect login and password$/ do
  fill_in "Login", :with => "blah"
  fill_in "Password", :with => "blah"
  click_button "Login"
end

Then /^I should see the (.+) "([^"]*)"$/ do |type, message|
  within "#notifications" do
    within ".#{type}" do
      page.should have_content(message)
    end
  end
end

Then /^I should see the (.+) page$/ do |page|
  current_path.should eq(eval("#{page}_path"))
end

Given /^I have an unapproved user account$/ do
  @user = Factory(:unapproved_user)
end
