require 'spec_helper'

RSpec.describe 'Password resets', type: :system do
  include EmailSpec::Matchers
  include EmailSpec::Helpers
  include ExtractDeviseTokenFromEmail

  it 'can be done from the login page' do
    user = create(:user, email: 'forgetful@mit.edu')

    visit new_user_session_path

    click_link 'Forgot password?'

    fill_in 'Email', with: 'forgetful@mit.edu'
    click_button 'Send Reset Email'

    expect(notifications).to have_content I18n.t('devise.passwords.send_instructions')

    expect(last_email).to be_delivered_to 'forgetful@mit.edu'

    user.reload

    token = extract_devise_token_from_email(last_email)

    visit edit_user_password_path(reset_password_token: token)

    fill_in 'New Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Change Password'

    expect(current_path).to eq receipts_path

    expect(notifications).to have_content 'Your password was changed successfully. You are now signed in.'
  end
end
