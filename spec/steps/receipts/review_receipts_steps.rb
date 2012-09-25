steps_for :review_receipts do
  step "I am on the receipts page" do
    visit receipts_path
  end

  step "I should see a button to sign out the packages received by :name" do  |name|
    within receipt_element name  do
      page.should have_button 'Sign Out'
    end
  end

  step "I sign out the packages received by :worker_name" do  |worker_name|
    within receipt_element worker_name  do
      click_button 'Sign Out'
    end
  end

  step "I should not see the sign out button for that receipt" do
    page.should_not have_button 'Sign Out'
  end

  step "I should see the receipt's details:" do |table|
    within receipts_collection do
      table.hashes.each do |attributes|
        attributes.each do |key, value|
          page.should have_css('td', text: value)
        end
      end
    end
  end

  step "I should not see others' receipt details:" do |table|
    within receipts_collection do
      table.hashes.each do |attributes|
        attributes.each do |key, value|
          page.should_not have_css('td', text: value)
        end
      end
    end
  end
end

# Shared step between receipt/delivery steps
# Unique enough to make global
step "I should see a link to email :worker_name at :worker_email" do |worker_name, worker_email|
  within find('td', text: worker_name) do
    page.should have_link(worker_name, href: "mailto:#{worker_email}")
  end
end

