Given /^the following package was received (\w+) by "([^"]*)" for "([^"]*)":$/ do |day, worker_email, recipient_email, table|
  attributes = table.hashes.first
  time = determine_day(day)
  worker = User.find_by_email!(worker_email)
  recipient = User.find_by_email!(recipient_email)
  FactoryGirl.create(:package,
                     worker: worker,
                     recipient: recipient,
                     delivered_by: attributes[:delivered_by],
                     comment: attributes[:comment],
                     created_at: time,
                     received_on: time.to_date
                    )
end

When /^I visit the deliveries page$/ do
  visit deliveries_path
end

When /^I go to the previous day of deliveries$/ do
  click_button 'Previous Day'
end

When /^I go to the next day of deliveries$/ do
  click_button 'Next Day'
end

Then /^I should see the delivery's received\-on timestamp for "([^"]*)"$/ do |day|
  time = determine_day(day).strftime(package_timestamp_format)
  within deliveries_collection do
    page.should have_css('td', text: time)
  end
end

Then /^I should see the delivery was by "([^"]*)"$/ do |company_name|
  page.should have_content company_name
end
