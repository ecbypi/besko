Given /^no one is logged in$/ do
  page.click_link 'Logout' if page.has_link? 'Logout'
  page.should_not have_link 'Logout'
  page.should have_link 'Log In'
end

Then /^I should be redirected to the home page$/ do
  current_path.should eq root_path
end
