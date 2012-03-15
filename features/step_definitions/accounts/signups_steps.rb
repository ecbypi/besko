Given /^the following user exists in the MIT LDAP directory:$/ do |table|
  attributes = table.hashes.first
  name = [attributes[:first_name], attributes[:last_name]].join(' ')
  result = MIT::LDAP::Search::InetOrgPerson.new(
    givenName: attributes[:first_name],
    sn: attributes[:last_name],
    uid: attributes[:login],
    mail: attributes[:email],
    cn: name
  )
  MIT::LDAP::Search.stub(:search).and_return([result])
end

Given /^I am on the sign up page$/ do
  visit new_user_registration_path
end

When /^I search for "([^"]*)" in the user search$/ do |search|
  fill_in 'Look yourself up in the MIT directory', with: search
  click_button 'Lookup'
end

When /^I select "([^"]*)" in the user search results$/ do |name|
  within user_element(name) do
    click_button 'This Is Me'
  end
end

Then /^an account confirmation email should be sent to "([^"]*)"$/ do |email|
  last_email.to.should include email
end

Then /^the search should be reset$/ do
  users_collection.all('tr').should be_empty
end

Then /^I should see that an account for "([^"]*)" already exists$/ do |name|
  within user_element(name) do
    page.should_not have_button 'This Is Me'
  end
end

Then /^the email should include the user's name "([^"]*)"$/ do |name|
  last_email_body.should match name
end

Then /^the email should include the user's email "([^"]*)"$/ do |email|
  last_email_body.should match email
end

Then /^the email should include the user's kerberos "([^"]*)"$/ do |kerberos|
  last_email_body.should match kerberos
end
