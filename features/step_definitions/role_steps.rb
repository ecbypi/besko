Given /^I am a besk worker with the email "([^"]*)"$/ do |email|
  user = User.find_by_email!(email)
  user.user_roles << UserRole.create(title: 'BeskWorker')
end
