require 'spec_helper'

feature 'Delivery', js: true do
  include AutocompleteSteps

  background do
    sign_in create(:user, :besk_worker)
  end

  context 'reviewal' do
    scenario 'shows worker, number of packages, deliverer and timestamp of delivery' do
      mshalp = create(:mshalp)
      mrhalp = create(:mrhalp, :besk_worker)

      receipts = []
      receipts << attributes_for(:receipt, user_id: mshalp.id, number_packages: 3455)
      receipts << attributes_for(:receipt, user_id: mrhalp.id, number_packages: 2)
      delivery = create(:delivery, user: mrhalp, deliverer: 'LaserShip', receipts_attributes: receipts)

      visit deliveries_path

      within delivery_element(text: 'LaserShip') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        page.should have_content delivery.created_at.strftime('%r')
        page.should have_content '3457'
        page.should_not have_button 'Delete'
      end

      within delivery_element(text: 'LaserShip') do
        find('td', text: 'LaserShip').click
      end

      within delivery_element(text: 'LaserShip') do
        page.should have_content 'Total 3457'
        page.should have_content 'Ms Helpline 3455'
        page.should have_content 'Micro Helpline 2'
      end
    end

    scenario 'allows deletion by admins' do
      click_link 'Logout'

      sign_in create(:user, :admin)

      create(:delivery, deliverer: 'FedEx', user: create(:mrhalp))
      create(:delivery, deliverer: 'FedEx', user: create(:mshalp))

      visit deliveries_path

      page.should have_delivery_element text: 'FedEx', count: 2

      within delivery_element(text: 'Micro Helpline') do
        click_button 'Delete'
      end

      page.should have_delivery_element text: 'FedEx', count: 1
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

      select 'UPS', from: 'deliverer'
      click_button 'Send Notifications'

      notifications.should have_content 'At least one recipient is required.'
    end

    scenario 'prevents users from being added twice' do
      create(:user, first_name: 'Walter', last_name: 'White')

      visit new_delivery_path

      fill_in_autocomplete with: 'walt'
      autocomplete_result('Walter White').click

      page.should have_receipt_element text: 'Walter White'

      fill_in_autocomplete with: 'walt'
      autocomplete_result('Walter White').click

      notifications.should have_content 'Walter White has already been added as a recipient.'
      page.should have_receipt_element text: 'Walter White', count: 1
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

      notifications.should have_content 'Jimmy McNulty has already been added as a recipient.'
      page.should have_receipt_element text: 'Jimmy McNulty', count: 1

      fill_in_autocomplete with: 'more'
      autocomplete_result('William Moreland').click

      page.should have_receipt_element text: 'William Moreland'

      visit new_delivery_path

      page.should have_receipt_element text: 'William Moreland'
      page.should have_receipt_element text: 'Jimmy McNulty'

      # Ensure individual recipients will be removed on page refresh
      within receipt_element(text: 'Jimmy McNulty') do
        click_button 'Remove'
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

      page.should have_receipt_element text: 'Micro Helpline'

      # Ensures user is created
      User.last.email.should eq 'mrhalp@mit.edu'

      select 'UPS', from: 'deliverer'
      click_button 'Send Notifications'

      page.should have_content 'Notifications Sent'

      last_email.to.should eq ['mrhalp@mit.edu']
    end
  end

  context 'search' do
    scenario 'by next or previous day' do
      mrhalp = create(:mrhalp, :besk_worker)
      mshalp = create(:mshalp, :besk_worker)
      create(:delivery, created_at: 1.day.ago, deliverer: 'UPS', user: mrhalp)
      create(:delivery, created_at: 1.day.from_now, deliverer: 'USPS', user: mshalp)

      visit deliveries_path

      click_button 'Previous Day'

      within delivery_element(text: 'UPS') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      2.times { click_button 'Next Day' }

      within delivery_element(text: 'USPS') do
        page.should have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
      end
    end

    scenario 'by selecting date on calendar' do
      day = Time.zone.local(2010, 10, 30)
      user = create(:mrhalp, :besk_worker)
      create(:delivery, created_at: day, deliverer: 'FedEx', user: user)

      visit deliveries_path

      click_button 'Change'

      within 'div#ui-datepicker-div' do
        find("select.ui-datepicker-year option:contains('#{day.year}')").select_option
        find("select.ui-datepicker-month option:contains('#{day.strftime('%b')}')").select_option
        find("a.ui-state-default:contains('#{day.day}')").click
      end

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
