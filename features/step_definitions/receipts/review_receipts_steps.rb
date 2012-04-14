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

Then /^I should see a link to email "([^"]*)" at "([^"]*)"$/ do |worker_name, worker_email|
  within find('td', text: worker_name) do
    page.should have_link(worker_name, href: "mailto:#{worker_email}")
  end
end

Then /^I should( not)? see (?:others'|the) receipt(?:'s|s')? details:$/ do |negate, table|
  method = determine_should(negate)
  within receipts_collection do
    table.hashes.each do |attributes|
      attributes.each do |key, value|
        page.send(method, have_css('td', text: value))
      end
    end
  end
end
