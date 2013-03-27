require 'spec_helper'

feature 'Accounts' do
  scenario 'can be created', js: true do
    stub_ldap!

    visit root_path

    click_link 'Sign Up'

    fill_in 'user-search', with: 'Micro Helpline'
    click_button 'Lookup'

    within user_element('Micro Helpline') do
      check 'This Is Me'
      click_button 'Request Account'
    end

    notifications.should have_content 'An email has been sent requesting approval of your account.'
    find('#user-search').value.should eq ''

    last_email.to.should eq ['besko@mit.edu']

    email_body = last_email.body.encoded

    email_body.should include 'Micro Helpline'
    email_body.should include 'mrhalp@mit.edu'
    email_body.should include 'mrhalp'

    fill_in 'user-search', with: 'Micro Helpline'
    click_button 'Lookup'

    within user_element('Micro Helpline') do
      page.should have_content 'Account Exists'
    end
  end

  scenario 'can have their passwords reset' do
    user = create(:user, email: 'forgetful@mit.edu')

    visit new_user_session_path

    click_link 'Forgot password?'

    fill_in 'Email', with: 'forgetful@mit.edu'
    click_button 'Send Reset Email'

    notifications.should have_content 'You will receive an email with instructions about how to reset your password in a few minutes.'

    last_email.to.should include 'forgetful@mit.edu'

    user = user.reload

    visit edit_user_password_path(reset_password_token: user.reset_password_token)

    fill_in 'New Password', with: 'password'
    fill_in 'Confirm New Password', with: 'password'
    click_button 'Change Password'

    current_path.should eq root_path

    notifications.should have_content 'Your password was changed successfully. You are now signed in.'
  end
end
