Given /^I am on the page to request a password reset$/ do
  visit new_user_password_path
end

When /^I submit the email "([^"]*)" for a password reset$/ do |email|
  fill_in 'Email', with: email
  click_button 'Send Reset Email'
end

Then /^I should be on the login page$/ do
  current_path.should eq new_user_session_path
end

Then /^an email with password reset instructions should be sent to "([^"]*)"$/ do |email|
  last_email.to.should include email
  last_email.subject.should match /Reset password instructions/
end

Given /^I requested a password reset for "([^"]*)"$/ do |email|
  steps %{
    Given I am on the page to request a password reset
    When I submit the email "#{email}" for a password reset
    Then I should be on the login page
  }
end

Given /^I visit the url from the email I was sent at "([^"]*)"$/ do |email|
  token = User.find_by_email!(email).reset_password_token
  visit edit_user_password_path reset_password_token: token
end

When /^I submit a new password "([^"]*)"$/ do |password|
  fill_in 'New Password', with: password
  fill_in 'Confirm New Password', with: password
  click_button 'Change Password'
end

Then /^I should be on the home page$/ do
  current_path.should eq root_path
end
