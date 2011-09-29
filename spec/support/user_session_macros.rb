module UserSessionMacros
  # only good when used with rack-test capybara driver
  def current_user
    current_user_session.try(:user)
  end

  # only good when used with rack-test capybara driver
  def current_user_session
    UserSession.find
  end

  def login(user)
    visit login_path
    fill_in "Email or Login", :with => user.login
    fill_in "Password", :with => user.password
    click_button "Login"
  end
end
