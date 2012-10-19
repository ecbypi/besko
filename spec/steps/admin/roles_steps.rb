steps_for :roles do
  step "I am on the page to manage roles" do
    visit user_roles_path
  end

  step "I should be able to switch between roles to manage" do
    roles = User.guises.map { |title| title.to_s.titleize }
    page.should have_select 'user_role_title', options: roles
  end

  step "I select :title from the list of roles" do |role|
    select role, from: 'user_role_title'
  end

  step "the list of users in the role should be hidden" do
    within '.users-in-role' do
      find('thead').should_not be_visible
    end
  end

  step "the list of users in the role should be visible" do
    sleep 1
    within '.users-in-role' do
      find('thead').should be_visible
    end
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
    user = User.find_by_login!(user)

    fill_in 'user-search', with: user.name

    step "I click on '#{user.name}' in the autocomplete list"
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
