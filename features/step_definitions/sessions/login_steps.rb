Given /^I am on the login page$/ do
  visit new_user_session_path
end

When /^I submit the email and password "([^"]*)" and "([^"]*)"$/ do |email, password|
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Sign In'
end

Then /^I should see the home page$/ do
  current_path.should eq root_path
end

Then /^I should see the login page$/ do
  current_path.should eq new_user_session_path
end
