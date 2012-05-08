step "I am on the login page" do
  visit new_user_session_path
end

step "I submit the email and password :email and :password" do |email, password|
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Sign In'
end

step "I should see the home page" do
  current_path.should eq root_path
end

step "I should see the login page" do
  current_path.should eq new_user_session_path
end

step "I am logged in with the email :email" do |email|
  click_link 'Logout' if page.has_link? 'Logout'

  step "a user exists with an email of '#{email}'"
  step "I am on the login page"
  step "I submit the email and password '#{email}' and password"
  step "I should see the home page"
end

step "no one is logged in" do
  page.click_link 'Logout' if page.has_link? 'Logout'
  page.should_not have_link 'Logout'
  page.should have_link 'Log In'
end
