require 'spec_helper'

feature 'Package receipts page' do
  let(:user) { create(:user) }

  background do
    sign_in user
  end

  scenario 'shows package receipt details' do
    delivery = create(:delivery, deliverer: 'UPS', user: create(:mrhalp, :desk_worker))
    receipt = create(
      :receipt,
      user: user,
      number_packages: 7593,
      delivery: delivery,
      comment: 'Fragile',
      created_at: Time.zone.local(2010, 10, 30, 10, 30)
    )

    visit receipts_path

    within receipt_element(text: 'UPS') do
      page.should have_content '7593'
      page.should have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      page.should have_content 'Fragile'
      page.should have_content '10:30 AM on Oct 30, 2010'
      page.should have_content 'Awaiting Pickup'
    end

    receipt.update!(signed_out_at: Time.zone.now)

    visit receipts_path

    within receipt_element(text: 'UPS') do
      page.should have_content Time.zone.now.strftime('%b %d, %Y')
    end
  end

  scenario 'is paginated and maintains page after releasing package' do
    create_list(:receipt, 11, user: user)

    visit receipts_path

    click_link 'Next', match: :first

    page.should have_receipt_element count: 1
  end

  scenario 'is shown only to signed in users' do
    sign_out!

    visit receipts_path

    current_path.should eq new_user_session_path
    page.should_not have_link 'Packages', href: receipts_path
  end

  scenario 'can be signed out by desk workers' do
    worker = create(:user, :desk_worker, first_name: 'Hugh', last_name: 'Lang')
    recipient = create(:user, first_name: 'Whip', last_name: 'Whitaker')
    receipt = build(:receipt, user: recipient)
    delivery = create(:delivery, receipts: [receipt], user: worker, deliverer: 'UPS')

    sign_out!
    sign_in worker

    visit delivery_path(delivery)

    within receipt_element(text: 'Whip Whitaker') do
      click_button 'Sign Out'
    end

    current_path.should eq delivery_path(delivery)
    notifications.should have_content 'Signed out package for Whip Whitaker delivered by UPS'

    within receipt_element(text: 'Whip Whitaker') do
      page.should have_content 'Picked Up'
    end
  end
end
