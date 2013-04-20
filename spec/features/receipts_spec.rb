require 'spec_helper'

feature 'Package receipts page' do
  let(:user) { create(:user) }

  background do
    sign_in user
  end

  scenario 'shows package receipt details' do
    delivery = create(:delivery, deliverer: 'UPS', user: create(:mrhalp, :besk_worker))
    create(
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

      click_button 'Sign Out'
    end

    within receipt_element(text: 'UPS') do
      page.should have_content Time.zone.now.strftime('%b %d, %Y')
    end
  end

  scenario 'is paginated and maintains page after releasing package' do
    create_list(:receipt, 11, user: user)

    visit receipts_path

    click_link 'Next', match: :first

    page.should have_receipt_element count: 1

    click_button 'Sign Out'

    page.should have_receipt_element count: 1
  end

  scenario 'is shown only to signed in users' do
    sign_out!

    visit receipts_path

    current_path.should eq new_user_session_path
    page.should_not have_link 'Packages', href: receipts_path
  end
end
