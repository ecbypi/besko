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

  step "I should see :name in the list of :position" do |name, position|
    within user_roles_collection do
      user_role_element(name).should be_present
    end
  end

  step "I should not see :name in the list of :position" do |name, position|
    expect { user_role_element(name) }.to raise_error Capybara::ElementNotFound
  end
end

placeholder :position do
  match /[\w ]+/ do |position|
    position
  end
end
