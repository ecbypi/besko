require 'spec_helper'

RSpec.describe "Delivery", :js, type: :system do
  before do
    sign_in create(:user, :desk_worker)
  end

  context "list" do
    it "shows who received the delivery, number of packages in it, " \
      "delivery company and time of day" do
      mshalp = create(:mshalp)
      mrhalp = create(:mrhalp, :desk_worker)

      delivered_at = Time.zone.local(2011, 11, 11, 15, 12)

      delivery = build(
        :delivery,
        user: mrhalp,
        deliverer: "LaserShip",
        created_at: delivered_at,
        updated_at: delivered_at
      )
      delivery.receipts.build attributes_for(:receipt, user_id: mshalp.id, number_packages: 9)
      delivery.receipts.build attributes_for(:receipt, user_id: mrhalp.id, number_packages: 2)
      delivery.save!

      visit deliveries_path

      within delivery_element(text: 'LaserShip') do
        expect(page).to have_content "Micro Helpline"
        expect(page).to have_content '3:12 pm'
        expect(page).to have_content human_attribute_name(Delivery, :package_count, count: 11)
      end
    end
  end

  context 'creation' do
    before do
      PeopleApiStub.setup
    end

    it 'validates delivery is ready to be created' do
      visit new_delivery_path

      # Force show the receipts table in the event that we are left in an
      # incorrect state.
      page.execute_script("$('.receipts').show()");

      click_button 'Send Notifications'

      expect(notifications).to have_content 'A deliverer is required to log a delivery.'

      select 'UPS', from: 'Delivery Company'
      click_button 'Send Notifications'

      expect(notifications).to have_content 'At least one recipient is required.'
    end

    it 'auto-increments number of packages for a user that is added twice' do
      create(:user, first_name: 'Walter', last_name: 'White')

      visit new_delivery_path

      fill_in "Recipient", with: "walt"
      autocomplete_result_element(text: "Walter White").click

      expect(page).to have_receipt_element text: 'Walter White'

      fill_in "Recipient", with: "walt"
      autocomplete_result_element(text: "Walter White").click

      expect(page).to have_receipt_element text: 'Walter White', count: 1

      within receipt_element(text: 'Walter White') do
        expect(find('input[type=number]').value).to eq '2'
      end
    end

    it 'package quantity in the url properly tracks input value' do
      batman = create(:user, first_name: 'Bruce', last_name: 'Wayne')

      visit new_delivery_path

      fill_in "Recipient", with: "Bru"
      autocomplete_result_element(text: "Bruce Wayne").click

      within receipt_element(text: 'Bruce Wayne') do
        find('input[type=number]').set 20
      end

      expect(current_url).to include new_delivery_path(:r => { batman.id => 20 })
    end

    it 'remembers the recipients that were added and how many packages they have' do
      jimmy = create(:user, first_name: 'Jimmy', last_name: 'McNulty')
      bunk = create(:user, first_name: 'William', last_name: 'Moreland')

      visit new_delivery_path

      fill_in "Recipient", with: 'mcnu'
      autocomplete_result_element(text: "Jimmy McNulty").click

      expect(page).to have_receipt_element text: 'Jimmy McNulty'
      expect(current_url).to include new_delivery_path(:r => { jimmy.id => 1 })

      visit current_url

      expect(page).to have_receipt_element text: 'Jimmy McNulty'

      fill_in "Recipient", with: 'mcnu'
      autocomplete_result_element(text: "Jimmy McNulty").click

      within receipt_element(text: 'Jimmy McNulty') do
        expect(find('input[type=number]').value).to eq '2'
      end
      expect(current_url).to include new_delivery_path(:r => { jimmy.id => 2 })

      fill_in "Recipient", with: "more"
      autocomplete_result_element(text: "William Moreland").click

      expect(page).to have_receipt_element text: 'William Moreland'
      expect(current_url).to include new_delivery_path(:r => { jimmy.id => 2, bunk.id => 1 })

      visit current_url

      expect(page).to have_receipt_element text: 'William Moreland'
      expect(page).to have_receipt_element text: 'Jimmy McNulty'

      # Ensure individual recipients will be removed on page refresh
      within receipt_element(text: 'Jimmy McNulty') do
        click_link 'Remove'
      end
      expect(current_url).to include new_delivery_path(:r => { bunk.id => 1 })

      visit current_url

      expect(page).to have_receipt_element text: 'William Moreland'
      expect(page).not_to have_receipt_element text: 'Jimmy McNulty'

      # Ensure all recipients will be removed on page refresh
      click_link 'Cancel'

      expect(page).not_to have_button I18n.t('helpers.submit.delivery.create')
      expect(current_url).not_to include new_delivery_path(:r => { bunk.id => 1 })

      visit current_url

      expect(page).not_to have_receipt_element text: 'William Moreland'
      expect(page).not_to have_receipt_element text: 'Jimmy McNulty'
    end

    it 'allows adding local DB and LDAP records' do
      create(:user, first_name: 'Jon', last_name: 'Snow')

      visit new_delivery_path

      expect(page).not_to have_receipts_element

      fill_in "Recipient", with: "snow"
      autocomplete_result_element(text: "Jon Snow").click

      expect(page).to have_receipt_element text: 'Jon Snow'

      fill_in "Recipient", with: "help"
      autocomplete_result_element(text: "Micro Helpline").click

      within receipt_element(text: 'Micro Helpline') do
        find('input[type=number]').set('2')
      end

      # Ensures user is created
      expect(User.last.email).to eq 'mrhalp@mit.edu'
      expect(page).not_to have_css '[data-loading]'

      select 'UPS', from: 'Delivery Company'
      click_button 'Send Notifications'

      expect(page).to have_content 'Notifications Sent'
      expect(last_email_sent).to be_delivered_to 'mrhalp@mit.edu'

      expect(current_path).to eq deliveries_path
      expect(page).to have_content 'Jon Snow 1'
      expect(page).to have_content 'Micro Helpline 2'
    end
  end

  context "searching can be done by the" do
    it "company that delivered the packages" do
      create(:delivery, deliverer: "LaserShip")
      create(:delivery, deliverer: "USPS")

      visit deliveries_path

      expect(page).to have_delivery_element count: 2

      select "LaserShip", from: "Delivered by"

      expect(page).to have_delivery_element count: 1
      expect(page).to have_delivery_element text: "LaserShip"
    end
  end

  it 'is accessible to besk workers' do
    sign_out!
    sign_in

    visit new_delivery_path

    expect(current_path).to eq receipts_path
    expect(navigation).not_to have_link 'Log New Delivery', href: new_delivery_path

    visit deliveries_path

    expect(current_path).to eq receipts_path
    expect(navigation).not_to have_link 'Deliveries', href: deliveries_path
  end
end
