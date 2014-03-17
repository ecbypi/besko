require 'spec_helper'

feature 'Sessions' do
  scenario 'are allowed for approved users' do
    approved = create(:user)
    unapproved = create(:user, :unconfirmed)

    visit root_path

    click_link 'Log In'

    fill_in 'Email', with: unapproved.email
    fill_in 'Password', with: unapproved.password
    click_button 'Sign In'

    current_path.should eq new_user_session_path
    notifications.should have_content I18n.t('devise.failure.unconfirmed')

    fill_in 'Email', with: approved.email
    fill_in 'Password', with: 'bad'
    click_button 'Sign In'

    current_path.should eq new_user_session_path
    notifications.should have_content 'Invalid email or password.'

    fill_in 'Email', with: approved.email
    fill_in 'Password', with: approved.password
    click_button 'Sign In'

    current_path.should eq root_path
    notifications.should have_content 'Signed in successfully.'
  end

  scenario 'are available via touchstone' do
    visit new_user_session_path

    page.should have_button 'Sign In with Touchstone'
  end
end
