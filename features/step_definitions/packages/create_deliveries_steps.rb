Given /^I am on the page to log deliveries$/ do
  visit new_delivery_path
end

When /^I search for "([^"]*)"$/ do |search|
  fill_in 'Search', with: search
end

Then /^I should see a receipt form for "([^"]*)"$/ do |name|
  within receipt_element(name) do
    page.should have_content name
  end
end

When /^I add "([^"]*)" to the list of recipient receipts$/ do |name|
  steps %{
    Given I search for "#{name}"
    And I click on "#{name}" in the autocomplete list
  }
end

When /^I specify "([^"]*)" received (\d+) packages?$/ do |name, number|
  within receipt_element(name) do
    find('input[type=number]').set(number)
  end
end

When /^I add the comment "([^"]*)" to "([^"]*)"'s delivery receipt$/ do |comment, name|
  within receipt_element(name) do
    find('textarea').set(comment)
  end
end

When /^I submit the notifications$/ do
  click_button 'Send Notifications'
end

When /^I specify the delivery is from "([^"]*)"$/ do |company_name|
  select company_name, from: 'Delivery Company'
end

Then /^a delivery notification should be sent to "([^"]*)"$/ do |email|
  last_email.to.should include email
end

Then /^the delivery from should be reset$/ do
  receipts_collection.find('tbody').all('tr').should be_empty
  find('#deliverer').value.should eq ''
  receipts_collection.find('thead').should_not be_visible
  receipts_collection.find('tfoot').should_not be_visible
end
