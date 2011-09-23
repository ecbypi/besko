require 'spec_helper'

describe "UserSessions" do
  let(:user) { Factory(:user) }

  it "logs user in when correct credentials are supplied" do
    visit login_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Login"
    current_path.should eq(root_path)
    page.should have_content("Login Successful")
  end
end
