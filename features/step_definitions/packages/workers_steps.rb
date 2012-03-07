Given /^packages were received (\w+) by "([^"]*)" for "([^"]*)":$/ do |day, worker_email, recipient_email, table|
  attributes = table.hashes.first
  time = determine_day(day)
  worker = User.find_by_email!(worker_email)
  recipient = User.find_by_email!(recipient_email)
  delivery = FactoryGirl.create(:delivery,
                                worker: worker,
                                created_at: time,
                                delivered_on: time.to_date,
                                deliverer: attributes[:delivered_by]
                               )
  FactoryGirl.create(:receipt,
                     recipient: recipient,
                     comment: attributes[:comment],
                     delivery: delivery
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

Then /^I should see (\w+)'s date$/ do |day|
  time = determine_day(day).strftime(package_date_format)
  page.should have_css('h2', text: time)
end

Then /^I should see the timestamp for the delivery from "([^"]*)"$/ do |company_name|
  timestamp_cell = model_resource(company_name).all('td').first
  timestamp_cell.text.should match(/\d{1,2}:\d{2} (A|P)M/)
end

Then /^I should see the delivery was by "([^"]*)"$/ do |company_name|
  within deliveries_collection do
    page.should have_content company_name
  end
end

Then /^I should see a total package count of (\d+)$/ do |package_count|
  within deliveries_collection do
    page.should have_css('td', text: package_count)
  end
end
