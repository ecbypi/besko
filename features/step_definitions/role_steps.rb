Given /^I am a besk worker with the email "([^"]*)"$/ do |email|
  user = User.find_by_email!(email)
  user.roles << Role.find_or_create_by_title('Besk Worker')
end
