Given /^there were (\d+) packages received (.+)$/ do |num, date|
  @packages = []
  @date = case date
          when 'yesterday' then Time.zone.now.to_date - 1
          when 'today' then Time.zone.now.to_date
          when 'tomorrow' then Time.zone.now.to_date + 1
          end
  num.to_i.times { @packages << Factory(:package, :received_on => @date) }
end

Then /^I should see a table with the packages received (.+)$/ do |date|
  rows = @packages.collect do |package|
    [
      package.recipient.name,
      package.worker.name,
      package.received_at,
      package.delivered_by,
      package.comment
    ]
  end
  page.should have_table('packages', :rows => rows)
end

When /^I click the (.+) day button$/ do |button|
  case button
  when 'previous'
    click_button 'Previous Day'
  when 'next'
    click_button 'Next Day'
  end
end
