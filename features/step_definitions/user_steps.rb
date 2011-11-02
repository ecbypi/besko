Given /^I am a worker$/ do
  @user = Factory(:besk_worker)
end

Given /^I am a user who has received packages$/ do
  @user = Factory(:user)
  @packages = @user.received_packages
end
