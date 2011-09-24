require 'spec_helper'

describe "UserSessions" do
  let(:user) { Factory(:user) }

  it "logs user in when correct login/password are supplied" do
    visit login_path
    fill_in "Email or Login", :with => user.login
    fill_in "Password", :with => user.password
    click_button "Login"
    current_path.should eq(root_path)
    page.should have_content("Login Successful")
  end

  it "logs user in when correct email/password are supplied" do
    visit login_path
    fill_in "Email or Login", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Login"
    current_path.should eq(root_path)
    page.should have_content("Login Successful")
  end
end
