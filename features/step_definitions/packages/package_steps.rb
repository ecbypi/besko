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
