require 'spec_helper'

feature 'Sidekiq admin dashboard' do
  # FIXME: Either provide a cleaner user experience or extract the dashboard
  # into a it's own rack application
  it 'is only accessible to admins' do
    sign_in
    visit sidekiq_web_path

    page.should_not have_content 'Sidekiq'

    visit root_path
    click_link 'Logout'
    sign_in create(:user, :besk_worker)
    visit sidekiq_web_path

    page.should_not have_content 'Sidekiq'

    visit root_path
    click_link 'Logout'
    sign_in create(:user, :admin)
    visit sidekiq_web_path

    page.should have_content 'Sidekiq'
  end
end
