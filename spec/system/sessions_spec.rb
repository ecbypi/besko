require 'spec_helper'

RSpec.describe 'Sessions', type: :system do
  it 'are allowed for confirmed and activated users' do
    user = create(:user, :unconfirmed, :inactive, email: 'guy@fake-email.com', password: 'password')

    visit root_path

    click_link 'Log In'

    fill_in 'Email', with: 'guy@fake-email.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'

    expect(current_path).to eq new_user_session_path
    expect(notifications).to have_content I18n.t('devise.failure.unconfirmed')

    user.confirm

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

  it "are available via touchstone if login handler is configured via ENV" do
    visit new_user_session_path

    expect(page).to have_button 'Sign In with Touchstone'

    login_handler = ENV.delete("SHIBBOLETH_LOGIN_HANDLER")
    visit new_user_session_path

    expect(page).not_to have_button "Sign In with Touchstone"

    ENV["SHIBBOLETH_LOGIN_HANDLER"] = login_handler
  end
end
