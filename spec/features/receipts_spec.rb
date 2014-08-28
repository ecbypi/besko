require 'spec_helper'

RSpec.feature 'Package receipts page' do
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
      expect(page).to have_content '7593'
      expect(page).to have_link 'Micro Helpline', href: 'mailto:mrhalp@mit.edu'
      expect(page).to have_content 'Fragile'
      expect(page).to have_content '10:30 AM on Oct 30, 2010'
      expect(page).to have_content 'Awaiting Pickup'
    end

    receipt.update!(signed_out_at: Time.zone.now)

    visit receipts_path

    within receipt_element(text: 'UPS') do
      expect(page).to have_content Time.zone.now.strftime('%b %d, %Y')
    end
  end

  scenario 'is paginated and maintains page after releasing package' do
    create_list(:receipt, 11, user: user)

    visit receipts_path

    click_link 'Next', match: :first

    expect(page).to have_receipt_element count: 1
  end

  scenario 'is shown only to signed in users' do
    sign_out!

    visit receipts_path

    expect(current_path).to eq new_user_session_path
    expect(page).not_to have_link 'Packages', href: receipts_path
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

    expect(current_path).to eq delivery_path(delivery)
    expect(notifications).to have_content 'Signed out package for Whip Whitaker delivered by UPS'

    within receipt_element(text: 'Whip Whitaker') do
      expect(page).to have_content 'Picked Up'
    end
  end
end
