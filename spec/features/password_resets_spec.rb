require 'spec_helper'

feature 'Password resets' do
  include EmailSpec::Matchers
  include EmailSpec::Helpers

  scenario 'can be done from the login page' do
    user = create(:user, email: 'forgetful@mit.edu')

    visit new_user_session_path

    click_link 'Forgot password?'

    fill_in 'Email', with: 'forgetful@mit.edu'
    click_button 'Send Reset Email'

    notifications.should have_content 'You will receive an email with instructions about how to reset your password in a few minutes.'

    last_email.should be_delivered_to 'forgetful@mit.edu'

    user = user.reload

    visit edit_user_password_path(reset_password_token: user.reset_password_token)

    fill_in 'New Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Change Password'

    current_path.should eq root_path

    notifications.should have_content 'Your password was changed successfully. You are now signed in.'
  end
end
