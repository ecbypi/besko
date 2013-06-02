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

  context 'are editable' do
    scenario 'to change their email address and password' do
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

    scenario 'to enter or change their forwarding address', js: true do
      user = create(:user)
      us_regions = Carmen::Country.coded('US').subregions.map(&:name)
      ca_regions = Carmen::Country.coded('CA').subregions.map(&:name)

      sign_in user

      visit edit_user_registration_path

      page.should have_select 'Country', selected: 'United States'
      page.should have_select 'State', with_options: us_regions

      fill_in 'Street', with: '77 Mass Ave'
      fill_in 'City', with: 'Cambridge'
      select 'Massachusetts', from: 'State'
      fill_in 'Postal code', with: '02139'
      click_button 'Save Forwarding Address'

      current_path.should eq edit_user_registration_path
      notifications.should have_content 'Updated forwarding address.'

      visit edit_user_registration_path

      page.should have_field 'Street', with: '77 Mass Ave'
      page.should have_field 'City', with: 'Cambridge'
      page.should have_select 'State', selected: 'Massachusetts'
      page.should have_field 'Postal code', with: '02139'
      page.should have_select 'Country', selected: 'United States'

      # with the `:priority` option, carmen-rails duplicates options
      select 'Canada', from: 'Country', match: :first
      page.should have_select 'State', with_options: ca_regions

      select 'Yukon', from: 'State'
      click_button 'Save Forwarding Address'

      current_path.should eq edit_user_registration_path
      notifications.should have_content 'Updated forwarding address.'
      page.should have_select 'Country', selected: 'Canada'
      page.should have_select 'State', selected: 'Yukon'
    end
  end
end
