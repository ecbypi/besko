require 'spec_helper'

RSpec.feature 'Sessions' do
  scenario 'are allowed for confirmed and activated users' do
    user = create(:user, :unconfirmed, :inactive, email: 'guy@fake-email.com', password: 'password')

    visit root_path

    click_link 'Log In'

    fill_in 'Email', with: 'guy@fake-email.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'

    expect(current_path).to eq new_user_session_path
    expect(notifications).to have_content I18n.t('devise.failure.unconfirmed')

    user.confirm!

    fill_in 'Email', with: 'guy@fake-email.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'

    expect(current_path).to eq new_user_session_path
    expect(notifications).to have_content I18n.t('devise.failure.inactive')

    user.activate!

    fill_in 'Email', with: 'guy@fake-email.com'
    fill_in 'Password', with: 'passw0rd'
    click_button 'Sign In'

    expect(current_path).to eq new_user_session_path
    expect(notifications).to have_content 'Invalid email or password.'

    fill_in 'Email', with: 'guy@fake-email.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'

    expect(current_path).to eq receipts_path
    expect(notifications).to have_content 'Signed in successfully.'
  end

  scenario 'are available via touchstone' do
    visit new_user_session_path

    expect(page).to have_button 'Sign In with Touchstone'
  end
end
