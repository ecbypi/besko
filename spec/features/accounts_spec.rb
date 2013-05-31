require 'spec_helper'

feature 'Accounts' do
  include EmailSpec::Matchers
  include EmailSpec::Helpers

  scenario 'can be created', js: true do
    stub_ldap!

    visit root_path

    click_link 'Sign Up'

    fill_in 'user-search', with: 'Micro Helpline'
    click_button 'Lookup'

    within user_element(text: 'Micro Helpline') do
      check 'This Is Me'
      click_button 'Request Account'
    end

    notifications.should have_content 'An email has been sent requesting approval of your account.'
    find('#user-search').value.should eq ''

    last_email.should be_delivered_to 'besko@mit.edu'

    last_email.should have_body_text 'Micro Helpline'
    last_email.should have_body_text 'mrhalp@mit.edu'
    last_email.should have_body_text 'mrhalp'

    fill_in 'user-search', with: 'Micro Helpline'
    click_button 'Lookup'

    within user_element(text: 'Micro Helpline') do
      page.should have_content 'Account Exists'
    end
  end

  context 'editing account information' do
    scenario 'can change their email address and password' do
      sign_in create(:user, password: 'sekrit', password_confirmation: 'sekrit')

      visit edit_user_registration_path

      fill_in 'Email', with: 'new@fake.com'
      fill_in 'Current Password', with: 'sekrit'
      fill_in 'New Password', with: 'sekr1t'
      fill_in 'Confirm New Password', with: 'sekr1t'
      click_button 'Update'

      current_path.should eq edit_user_registration_path
      page.should have_field 'Email', with: 'new@fake.com'

      click_link 'Logout'

      visit new_user_session_path

      fill_in 'Email', with: 'new@fake.com'
      fill_in 'Password', with: 'sekr1t'
      click_button 'Sign In'

      current_path.should eq root_path
      page.should have_content 'Signed in successfully.'
    end
  end
end
