require 'spec_helper'

RSpec.describe 'Accounts can be edited', type: :system do
  it 'to change their email address and password' do
    sign_in create(:user, password: 'sekrit', password_confirmation: 'sekrit')

    visit edit_user_registration_path

    fill_in 'Email', with: 'new@fake.com'
    fill_in 'Current Password', with: 'sekrit'
    fill_in 'New Password', with: 'sekr1t'
    fill_in 'Confirm New Password', with: 'sekr1t'
    click_button 'Update'

    expect(current_path).to eq edit_user_registration_path
    expect(page).to have_field 'Email', with: 'new@fake.com'

    click_link 'Logout'

    visit new_user_session_path

    fill_in 'Email', with: 'new@fake.com'
    fill_in 'Password', with: 'sekr1t'
    click_button 'Sign In'

    expect(current_path).to eq receipts_path
    expect(page).to have_content 'Signed in successfully.'
  end
end
