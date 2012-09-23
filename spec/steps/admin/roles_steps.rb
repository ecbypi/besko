steps_for :roles do
  step "I am on the page to manage roles" do
    visit user_roles_path
  end

  step "I should be able to switch between roles to manage" do
    roles = User.guises.map { |title| title.to_s.titleize }
    page.should have_select 'Select a role:', options: roles
  end

  step "I select :title from the list of roles" do |role|
    select role, from: 'Select a role:'
  end

  step "the list of users in the role should be hidden" do
    user_roles_collection.should_not be_visible
  end

  step "the list of users in the role should be visible" do
    sleep 1 # table isn't being rendered fast enough
    user_roles_collection.should be_visible
  end

  step "I try to add a user without specifying any information" do
    click_button 'Add User'
  end

  step "I try to add a user without specifying one" do
    step "I try to add a user without specifying any information"
  end

  step "I should see :name in the list of :position" do |name, position|
    within user_roles_collection do
      user_role_element(name).should be_present
    end
  end

  step "I should not see :name in the list of :position" do |name, position|
    expect { user_role_element(name) }.to raise_error Capybara::ElementNotFound
  end

  step "I add :user to the selected role" do |user|
    fill_in 'User to add:', with: user

    step 'I click on "Micro Helpline" in the autocomplete list'

    click_button 'Add User'
  end

  step "I should see :name has been added to the list of :position" do |name, position|
    step "I should see '#{name}' in the list of #{position}"
  end

  step "the form to add users to a role should be reset" do
    find('input#user_role_user_id').value.should eq ''
    find('input#user-search').value.should eq ''
  end

  step "I remove :name from the selected role" do |name|
    within user_role_element(name) do
      click_button 'Remove'
    end
  end
end

placeholder :position do
  match /[\w ]+/ do |position|
    position
  end
end
