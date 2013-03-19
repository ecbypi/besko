require 'spec_helper'

feature 'Manging user roles', js: true do
  background do
    sign_in create(:user, :admin)
  end

  scenario 'allows switching between roles on a single page' do
    roles = User.guises.inject([]) do |collection, guise|
      user_with_role = create(:user, first_name: guise, last_name: 'Worker')
      collection << create(:user_role, title: guise, user: user_with_role)
    end

    visit user_roles_path

    # Ensure that with no role specified, nothing is visible
    page.should_not have_user_roles_collection

    # Verify that the view is updated appropriately when switching roles
    User.guises.each do |guise|
      select guise.to_s.titleize, from: 'user_role_title'

      page.should have_user_role_element "#{guise} Worker"

      User.guises.select { |g| g != guise }.each do |g|
        page.should_not have_user_role_element "#{g} Worker"
      end
    end

    # Remove all BeskWorker roles to assert that the page is properly emptied
    UserRole.delete_all(title: 'BeskWorker')
    select 'Besk Worker', from: 'user_role_title'

    page.should_not have_user_roles_collection
  end

  scenario 'page is refresh-able' do
    create(:user, :besk_worker, first_name: 'Jon', last_name: 'Snow')

    visit user_role_path(id: :BeskWorker)

    current_path.should match /\/roles\/BeskWorker/

    # FIXME: This should use capybara's `has_select?` matcher
    find('#user_role_title').value.should eq 'BeskWorker'
    user_roles_collection.should have_user_role_element 'Jon Snow'
  end

  scenario 'allows adding and removing users' do
    create(:user, first_name: 'Tyrion', last_name: 'Lannister')

    visit user_roles_path

    select 'Besk Worker', from: 'user_role_title'
    fill_in 'user-search', with: 'lannister'
    user_element('Tyrion').click

    page.should have_user_role_element 'Tyrion Lannister'
    page.should have_field 'user-search', with: nil
    notifications.should have_content 'Tyrion Lannister is now a BeskWorker'

    fill_in 'user-search', with: 'lannister'
    user_element('Tyrion').click

    notifications.should have_content 'User is already in the selected role'

    within user_role_element('Tyrion Lannister') do
      click_button 'Remove'
    end

    user_roles_collection.should_not have_user_role_element 'Tyrion Lannister'
    notifications.should have_content 'Tyrion Lannister is no longer a BeskWorker'
  end

  scenario 'can only be done by admins' do
    sign_out!
    sign_in create(:user, :besk_worker)

    visit user_roles_path

    current_path.should eq root_path
    navigation.should_not have_link 'Positions', href: user_roles_path
  end
end
