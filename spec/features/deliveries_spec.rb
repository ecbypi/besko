require 'spec_helper'

feature 'Delivery', js: true do
  background do
    sign_in create(:user, :besk_worker)
  end

  context 'reviewal' do
    scenario 'shows worker, number of packages, deliverer and timestamp of delivery' do
      mshalp = create(:mshalp)
      mrhalp = create(:mrhalp, :besk_worker)

      # FIXME: Is there a way to build a receipt without a delivery other than
      # setting `delivery` to nil
      receipt = build(:receipt, recipient: mshalp, number_packages: 3455, delivery: nil)
      delivery = create(:delivery, worker: mrhalp, deliverer: 'LaserShip', receipts: [receipt])

      visit deliveries_path

      within delivery_element('LaserShip') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
        page.should have_content delivery.created_at.strftime('%r')
        page.should have_content '3455'
      end
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

      fill_in 'user-search', with: 'walt'
      user_element('Walter White').click

      page.should have_receipt_element text: 'Walter White'

      fill_in 'user-search', with: 'walt'
      user_element('Walter White').click

      notifications.should have_content 'Walter White has already been added as a recipient.'
      page.should have_receipt_element text: 'Walter White', count: 1
    end

    scenario 'allows adding local DB and LDAP records' do
      create(:user, first_name: 'Jon', last_name: 'Snow')

      visit new_delivery_path

      page.should_not have_receipts_collection

      fill_in 'user-search', with: 'snow'
      user_element('Jon Snow').click

      page.should have_receipt_element text: 'Jon Snow'

      fill_in 'user-search', with: 'help'
      user_element('Micro Helpline').click

      page.should have_receipt_element text: 'Micro Helpline'

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
      create(:delivery, created_at: 1.day.ago, deliverer: 'UPS', worker: mrhalp)
      create(:delivery, created_at: 1.day.from_now, deliverer: 'USPS', worker: mshalp)

      visit deliveries_path

      click_button 'Previous Day'

      within delivery_element('UPS') do
        page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      end

      2.times { click_button 'Next Day' }

      within delivery_element('USPS') do
        page.should have_link 'Ms Helpline', href: 'mailto:mshalp@mit.edu'
      end
    end

    scenario 'by selecting date on calendar' do
      day = Time.zone.local(2010, 10, 30)
      user = create(:mrhalp, :besk_worker)
      create(:delivery, created_at: day, deliverer: 'FedEx', worker: user)

      visit deliveries_path

      click_button 'Change'

      within 'div#ui-datepicker-div' do
        find("select.ui-datepicker-year option:contains('#{day.year}')").select_option
        find("select.ui-datepicker-month option:contains('#{day.strftime('%b')}')").select_option
        find("a.ui-state-default:contains('#{day.day}')").click
      end

      within delivery_element('FedEx') do
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
