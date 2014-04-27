require 'spec_helper'

feature 'Delivery', js: true do
  include AutocompleteSteps
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
      delivery = create(
        :delivery,
        user: mrhalp,
        deliverer: 'LaserShip',
        created_at: Time.zone.local(2011, 11, 11, 15, 12, 9),
        receipts_attributes: receipts
      )

      visit deliveries_path(date: '2011-11-11')

      within delivery_element(text: 'LaserShip') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        page.should have_content '03:12:09 pm'
        page.should have_content '3457'
        page.should_not have_button 'Delete'
      end

      within delivery_element(text: 'LaserShip') do
        click_link 'Details'
      end

      current_path.should eq delivery_path(delivery)

      within delivery_element(text: 'LaserShip') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        page.should have_content 'Delivered On Friday, November 11, 2011'
        page.should have_content 'Total Packages 3457'
      end

      within receipt_element(text: 'Ms Helpline') do
        page.should have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
        page.should have_content '3455'
      end

      within receipt_element(text: 'Micro Helpline') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        page.should have_content '2'
      end
    end

    scenario 'allows sorting by time of day received, remembering sorting across page refresh' do
      Timecop.travel(5.minutes.ago) do
        create(:delivery, deliverer: 'UPS')
      end
      create(:delivery, deliverer: 'LaserShip')

      visit deliveries_path

      'LaserShip'.should appear_before 'UPS'

      within deliveries_collection do
        click_link 'Delivered At'
      end

      sleep 1
      'UPS'.should appear_before 'LaserShip'

      visit current_url

      'UPS'.should appear_before 'LaserShip'

      visit deliveries_path

      current_url.should include 'sort=oldest'
      'UPS'.should appear_before 'LaserShip'
      # hacky way to ensure the sort arrow is pointing the right way
      page.should have_css '.sort-column.up'
    end

    scenario 'allows deletion by admins' do
      create(:delivery, deliverer: 'FedEx', user: create(:mrhalp))
      create(:delivery, deliverer: 'FedEx', user: create(:mshalp))

      visit deliveries_path

      within deliveries_collection do
        page.should_not have_button 'Delete'
      end

      click_link 'Logout'

      sign_in create(:user, :admin)

      visit deliveries_path

      page.should have_delivery_element text: 'FedEx', count: 2

      within delivery_element(text: 'Micro Helpline') do
        click_button 'Delete'
      end

      page.should have_delivery_element text: 'FedEx', count: 1
      current_url.should include deliveries_path(date: Time.zone.now.to_date, sort: 'newest')
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

      notifications.should have_content 'A deliverer is required to log a delivery.'

      select 'UPS', from: 'Delivery Company'
      click_button 'Send Notifications'

      notifications.should have_content 'At least one recipient is required.'
    end

    scenario 'auto-increments number of packages for a user that is added twice' do
      create(:user, first_name: 'Walter', last_name: 'White')

      visit new_delivery_path

      fill_in_autocomplete with: 'walt'
      autocomplete_result('Walter White').click

      page.should have_receipt_element text: 'Walter White'

      fill_in_autocomplete with: 'walt'
      autocomplete_result('Walter White').click

      page.should have_receipt_element text: 'Walter White', count: 1

      within receipt_element(text: 'Walter White') do
        find('input[type=number]').value.should eq '2'
      end
    end

    scenario 'remembers the recipients that were added' do
      create(:user, first_name: 'Jimmy', last_name: 'McNulty')
      create(:user, first_name: 'William', last_name: 'Moreland')

      visit new_delivery_path

      fill_in_autocomplete with: 'mcnu'
      autocomplete_result('Jimmy McNulty').click

      page.should have_receipt_element text: 'Jimmy McNulty'

      visit new_delivery_path

      page.should have_receipt_element text: 'Jimmy McNulty'

      # Ensure it still checks uniqueness of recipients
      fill_in_autocomplete with: 'mcnu'
      autocomplete_result('Jimmy McNulty').click

      within receipt_element(text: 'Jimmy McNulty') do
        find('input[type=number]').value.should eq '2'
      end

      fill_in_autocomplete with: 'more'
      autocomplete_result('William Moreland').click

      page.should have_receipt_element text: 'William Moreland'

      visit new_delivery_path

      page.should have_receipt_element text: 'William Moreland'
      page.should have_receipt_element text: 'Jimmy McNulty'

      # Ensure individual recipients will be removed on page refresh
      within receipt_element(text: 'Jimmy McNulty') do
        click_link 'Remove'
      end

      visit new_delivery_path

      page.should have_receipt_element text: 'William Moreland'
      page.should_not have_receipt_element text: 'Jimmy McNulty'

      # Ensure all recipients will be removed on page refresh
      click_link 'Cancel'

      visit new_delivery_path

      page.should_not have_receipt_element text: 'William Moreland'
      page.should_not have_receipt_element text: 'Jimmy McNulty'
    end

    scenario 'allows adding local DB and LDAP records' do
      create(:user, first_name: 'Jon', last_name: 'Snow')

      visit new_delivery_path

      page.should_not have_receipts_collection

      fill_in_autocomplete with: 'snow'
      autocomplete_result('Jon Snow').click

      page.should have_receipt_element text: 'Jon Snow'

      fill_in_autocomplete with: 'help'
      autocomplete_result('Micro Helpline').click

      within receipt_element(text: 'Micro Helpline') do
        find('input[type=number]').set('2')
      end

      # Ensures user is created
      User.last.email.should eq 'mrhalp@mit.edu'

      select 'UPS', from: 'Delivery Company'
      click_button 'Send Notifications'

      page.should have_content 'Notifications Sent'
      last_email.should be_delivered_to 'mrhalp@mit.edu'

      current_path.should eq delivery_path(Delivery.last!)
      page.should have_content 'Jon Snow 1'
      page.should have_content 'Micro Helpline 2'
    end
  end

  context 'search' do
    scenario 'by next or previous day' do
      mrhalp = create(:mrhalp, :desk_worker)
      mshalp = create(:mshalp, :desk_worker)
      create(:delivery, created_at: 1.day.ago, deliverer: 'UPS', user: mrhalp)
      create(:delivery, created_at: 1.day.from_now, deliverer: 'USPS', user: mshalp)

      visit deliveries_path

      click_link 'Previous Day'

      within delivery_element(text: 'UPS') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      click_link 'Next Day'
      sleep 1
      click_link 'Next Day'

      within delivery_element(text: 'USPS') do
        page.should have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
      end
    end

    scenario 'by selecting date on calendar' do
      day = Time.zone.local(2010, 10, 30)
      user = create(:mrhalp, :desk_worker)
      create(:delivery, created_at: day, deliverer: 'FedEx', user: user)

      visit deliveries_path

      click_button 'Change'

      within 'div#ui-datepicker-div' do
        find('select.ui-datepicker-year option', text: day.year.to_s).select_option
        find('select.ui-datepicker-month option', text: day.strftime('%b')).select_option
        find('a.ui-state-default:not(.ui-priority-secondary)', text: day.day.to_s).click
      end

      current_url.should include deliveries_path(date: '2010-10-30', sort: 'newest')

      within delivery_element(text: 'FedEx') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      visit current_url

      within delivery_element(text: 'FedEx') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end
    end
  end

  scenario 'is accessible to besk workers' do
    sign_out!
    sign_in

    visit new_delivery_path

    current_path.should eq root_path
    navigation.should_not have_link 'Log New Delivery', href: new_delivery_path

    visit deliveries_path

    current_path.should eq root_path
    navigation.should_not have_link 'Deliveries', href: deliveries_path
  end
end
