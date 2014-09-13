require 'spec_helper'

RSpec.feature 'Delivery', js: true do
  include EmailSpec::Matchers
  include EmailSpec::Helpers

  background do
    sign_in create(:user, :desk_worker)
  end

  context 'reviewal' do
    scenario 'shows worker, number of packages, deliverer and timestamp of delivery' do
      mshalp = create(:mshalp)
      mrhalp = create(:mrhalp, :desk_worker)

      receipts = []
      receipts << attributes_for(:receipt, user_id: mshalp.id, number_packages: 3455)
      receipts << attributes_for(:receipt, user_id: mrhalp.id, number_packages: 2)
      delivery = build(:delivery, user: mrhalp, deliverer: 'LaserShip', receipts_attributes: receipts)

      Timecop.travel(Time.zone.local(2011, 11, 11, 15, 12, 9)) do
        delivery.save!
      end

      visit deliveries_path(date: '2011-11-11')

      within delivery_element(text: 'LaserShip') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        expect(page).to have_content '03:12:09 pm'
        expect(page).to have_content '3457'
        expect(page).not_to have_button 'Delete'
      end

      within delivery_element(text: 'LaserShip') do
        click_link 'Details'
      end

      expect(current_path).to eq delivery_path(delivery)

      within delivery_element(text: 'LaserShip') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        expect(page).to have_content 'Delivered On Friday, November 11, 2011'
        expect(page).to have_content 'Total Packages 3457'
      end

      within receipt_element(text: 'Ms Helpline') do
        expect(page).to have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
        expect(page).to have_content '3455'
      end

      within receipt_element(text: 'Micro Helpline') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        expect(page).to have_content '2'
      end
    end

    scenario 'allows sorting by time of day received, remembering sorting across page refresh' do
      Timecop.travel(5.minutes.ago) do
        create(:delivery, deliverer: 'UPS')
      end
      create(:delivery, deliverer: 'LaserShip')

      visit deliveries_path

      expect('LaserShip').to appear_before 'UPS'

      within deliveries_element do
        click_link 'Delivered At'
      end

      sleep 1
      expect('UPS').to appear_before 'LaserShip'

      visit current_url

      expect('UPS').to appear_before 'LaserShip'

      visit deliveries_path

      expect(current_url).to include 'sort=oldest'
      expect('UPS').to appear_before 'LaserShip'
      # hacky way to ensure the sort arrow is pointing the right way
      expect(page).to have_css '.sort-column.up'
    end

    scenario 'allows deletion by admins' do
      create(:delivery, deliverer: 'FedEx', user: create(:mrhalp))
      create(:delivery, deliverer: 'FedEx', user: create(:mshalp))

      visit deliveries_path

      within deliveries_element do
        expect(page).not_to have_button 'Delete'
      end

      click_link 'Logout'

      sign_in create(:user, :admin)

      visit deliveries_path

      expect(page).to have_delivery_element text: 'FedEx', count: 2

      within delivery_element(text: 'Micro Helpline') do
        click_button 'Delete'
      end

      expect(page).to have_delivery_element text: 'FedEx', count: 1
      expect(current_url).to include deliveries_path(date: Time.zone.now.to_date, sort: 'newest')
    end
  end

  context 'creation' do
    before do
      stub_ldap!
    end

    scenario 'validates delivery is ready to be created' do
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

    scenario 'auto-increments number of packages for a user that is added twice' do
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

    scenario 'package quantity in the url properly tracks input value' do
      batman = create(:user, first_name: 'Bruce', last_name: 'Wayne')

      visit new_delivery_path

      fill_in "Recipient", with: "Bru"
      autocomplete_result_element(text: "Bruce Wayne").click

      within receipt_element(text: 'Bruce Wayne') do
        find('input[type=number]').set 20
      end

      expect(current_url).to include new_delivery_path(:r => { batman.id => 20 })
    end

    scenario 'remembers the recipients that were added and how many packages they have' do
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

    scenario 'allows adding local DB and LDAP records' do
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

      select 'UPS', from: 'Delivery Company'
      click_button 'Send Notifications'

      expect(page).to have_content 'Notifications Sent'
      expect(last_email).to be_delivered_to 'mrhalp@mit.edu'

      expect(current_path).to eq delivery_path(Delivery.last!)
      expect(page).to have_content 'Jon Snow 1'
      expect(page).to have_content 'Micro Helpline 2'
    end
  end

  context 'search' do
    scenario 'by next or previous day' do
      mrhalp = create(:mrhalp, :desk_worker)
      mshalp = create(:mshalp, :desk_worker)

      Timecop.travel(1.day.ago) do
        create(:delivery, deliverer: 'UPS', user: mrhalp)
      end

      Timecop.travel(1.day.from_now) do
        create(:delivery, deliverer: 'USPS', user: mshalp)
      end

      visit deliveries_path

      click_link 'Previous Day'

      within delivery_element(text: 'UPS') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      click_link 'Next Day'
      sleep 1
      click_link 'Next Day'

      within delivery_element(text: 'USPS') do
        expect(page).to have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
      end
    end

    scenario 'by selecting date on calendar' do
      day = Time.zone.local(2010, 10, 30)
      user = create(:mrhalp, :desk_worker)

      Timecop.travel(day) do
        create(:delivery, deliverer: 'FedEx', user: user)
      end

      visit deliveries_path

      click_button 'Change'

      within 'div#ui-datepicker-div' do
        find('select.ui-datepicker-year option', text: day.year.to_s).select_option
        find('select.ui-datepicker-month option', text: day.strftime('%b')).select_option
        find('a.ui-state-default:not(.ui-priority-secondary)', text: day.day.to_s).click
      end

      expect(current_url).to include deliveries_path(date: '2010-10-30', sort: 'newest')

      within delivery_element(text: 'FedEx') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      visit current_url

      within delivery_element(text: 'FedEx') do
        expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end
    end
  end

  scenario 'is accessible to besk workers' do
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
