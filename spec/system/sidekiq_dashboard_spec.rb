require 'spec_helper'

RSpec.describe 'Sidekiq admin dashboard', type: :system do
  # FIXME: Either provide a cleaner user experience or extract the dashboard
  # into a it's own rack application
  it 'is only accessible to admins' do
    sign_in
    visit sidekiq_web_path

    expect(page.driver.response).not_to be_successful

    visit root_path
    click_link 'Logout'
    sign_in create(:user, :desk_worker)
    visit sidekiq_web_path

    expect(page.driver.response).not_to be_successful

    visit root_path
    click_link 'Logout'
    sign_in create(:user, :admin)
    visit sidekiq_web_path

    expect(page.driver.response).to be_successful
  end
end
