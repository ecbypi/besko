Given /^I am on the packages page for recipients$/ do
  visit packages_path
end

Then /^I should see the package information:$/ do |table|
  within '[data-collection="packages"]' do
    table.hashes.each do |attributes|
      worker = User.find_by_email!(attributes[:received_by])
      page.should have_css('td', text: worker.name)
      page.should have_css('td', text: attributes[:delivered_by])
      page.should have_css('td', text: attributes[:comment])
      page.should have_css('td', text: attributes[:received_on])
    end
  end
end

Then /^I should see a button to sign out the package$/ do
  page.should have_button('Sign Out')
end

When /^I sign out the package received by "([^"]*)"$/ do |worker_name|
  click_button 'Sign Out'
end

Then /^I should not see the sign out button for that package$/ do
  page.should_not have_button('Sign Out')
end
