Given /^I am on the receipts page$/ do
  visit receipts_path
end

Then /^I should see a button to sign out the packages received by "([^"]*)"$/ do |name|
  within model_resource name  do
    page.should have_button 'Sign Out'
  end
end

When /^I sign out the packages received by "([^"]*)"$/ do |worker_name|
  within model_resource worker_name  do
    click_button 'Sign Out'
  end
end

Then /^I should not see the sign out button for that receipt$/ do
  page.should_not have_button 'Sign Out'
end
