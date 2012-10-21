steps_for :deliveries do
  step "I am on the page to log deliveries" do
    visit new_delivery_path
  end

  step "I search for :search" do  |search|
    fill_in 'user-search', with: search
  end

  step "I should see a receipt form for :name" do  |name|
    within receipt_element(name) do
      page.should have_content name

      input = find('input[type=hidden]')
      input.value.should be_present
    end
  end

  step "I add :name to the list of recipient receipts" do  |name|
    step "I search for '#{name}'"
    step "I click on '#{name}' in the autocomplete list"
  end

  step "I specify :name received :number package(s)" do |name, number|
    within receipt_element(name) do
      find('input[type=number]').set(number)
    end
  end

  step "I add the comment :comment to :name's delivery receipt" do |comment, name|
    within receipt_element(name) do
      find('textarea').set(comment)
    end
  end

  step "I submit the notifications" do
    click_button 'Send Notifications'
  end

  step "I specify the delivery is from :company_name" do  |company_name|
    select company_name, from: 'Delivery Company'
  end

  step "a delivery notification should be sent to :email" do  |email|
    last_email.to.should include email
  end

  step "the delivery from should be reset" do
    receipts_collection.all('tr').should be_empty
    find('#delivery_deliverer').value.should eq ''
    receipts_collection.parent.find('thead').should_not be_visible
    receipts_collection.parent.find('tfoot').should_not be_visible
  end
end
