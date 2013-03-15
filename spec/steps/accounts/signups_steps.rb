steps_for :signups do
  step "the following user exists in the MIT LDAP directory:" do |table|
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

  step "I am on the sign up page" do
    visit new_user_registration_path
  end

  step "I search for :search in the user search" do  |search|
    fill_in 'Look yourself up in the MIT directory', with: search
    click_button 'Lookup'
  end

  step "I select :name in the user search results" do  |name|
    within user_element(name) do
      check 'This Is Me'
      click_button 'Request Account'
    end
  end

  step "an account confirmation email should be sent to :email" do  |email|
    last_email.to.should include email
  end

  step "the search should be reset" do
    page.should_not have_css '.search-results'
  end

  step "I should see that an account for :name already exists" do  |name|
    within user_element(name) do
      page.should_not have_button 'This Is Me'
    end
  end

  step "the email should include the user's name :name" do  |name|
    last_email_body.should match name
  end

  step "the email should include the user's email :email" do  |email|
    last_email_body.should match email
  end

  step "the email should include the user's kerberos :kerberos" do  |kerberos|
    last_email_body.should match kerberos
  end
end
