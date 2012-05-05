steps_for :deliveries do
  step "packages were received :day_word by :worker_email for :recipient_email:" do |time, worker_email, recipient_email, table|
    attributes = table.hashes.first
    worker = User.find_by_email!(worker_email)
    recipient = User.find_by_email!(recipient_email)
    delivery = create(:delivery,
                      worker: worker,
                      created_at: time,
                      delivered_on: time.to_date,
                      deliverer: attributes['delivered_by']
                     )
    create(:receipt,
           recipient: recipient,
           comment: attributes[:comment],
           delivery: delivery
          )
  end

  step "I visit the deliveries page" do
    visit deliveries_path
  end

  step "I should see the date :date" do  |date|
    find('h2 input.hasDatepicker').value.should eq date
  end

  step "I should see :day_word date" do |time|
    time = time.strftime('%A, %B %d, %Y')
    step "I should see the date '#{time}'"
  end

  step "I should see the timestamp for the delivery from :company_name" do  |company_name|
    timestamp_cell = delivery_element(company_name).all('td').first
    timestamp_cell.text.should match(/\d{1,2}:\d{2} (A|P)M/)
  end

  step "I should see the delivery was by :company_name" do  |company_name|
    within deliveries_collection do
      page.should have_content company_name
    end
  end

  step "I should see a total package count of :package_count" do |package_count|
    within deliveries_collection do
      page.should have_css('td', text: package_count)
    end
  end

  placeholder :day_word do
    match /(today|tomorrow|yesterday)(?:'s)?/ do |day_word|
      date = case day_word
             when 'yesterday' then 1.day.ago
             when 'today' then Time.zone.now
             when 'tomorrow' then 1.day.from_now
             end.to_date.to_s
      Time.zone.parse("#{date} 12:30:30")
    end
  end
end
