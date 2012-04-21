Given /^packages were received (\w+) by "([^"]*)" for "([^"]*)":$/ do |day, worker_email, recipient_email, table|
  attributes = table.hashes.first
  time = determine_day(day)
  worker = User.find_by_email!(worker_email)
  recipient = User.find_by_email!(recipient_email)
  delivery = create(:delivery,
                    worker: worker,
                    created_at: time,
                    delivered_on: time.to_date,
                    deliverer: attributes[:delivered_by]
                   )
  create(:receipt,
         recipient: recipient,
         comment: attributes[:comment],
         delivery: delivery
        )
end

When /^I visit the deliveries page$/ do
  visit deliveries_path
end

Then /^I should see the date "([^"]*)"$/ do |date|
  find('h2 input.hasDatepicker').value.should eq date
end

Then /^I should see (\w+)'s date$/ do |day|
  time = determine_day(day).strftime(package_date_format)
  steps %{
    Then I should see the date "#{time}"
  }
end

Then /^I should see the timestamp for the delivery from "([^"]*)"$/ do |company_name|
  timestamp_cell = delivery_element(company_name).all('td').first
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
