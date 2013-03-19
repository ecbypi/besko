@roles @javascript
Feature: Role management
  In order to give users permissions
  As an admin
  I need to add users to roles

  Background:
    Given I am logged in with the email "admin@mit.edu"
    And I am an admin with the email "admin@mit.edu"
    And I am on the page to manage roles
    And the user mrhalp exists locally
    And the user mshalp exists locally

  Scenario: view all existing roles
    Then I should be able to switch between roles to manage

  Scenario: hides and shows roles table as needed
    Given mrhalp is an admin
    When I select "Besk Worker" from the list of roles
    Then the list of users in the role should be hidden

    When I select "Admin" from the list of roles
    Then the list of users in the role should be visible

  Scenario: lists users in a role when that role is selected
    Given mrhalp is a besk worker
    And mshalp is an admin
    When I select "Besk Worker" from the list of roles
    Then I should see "Micro Helpline" in the list of besk workers
    And I should not see "Ms Helpline" in the list of besk workers

    When I select "Admin" from the list of roles
    Then I should see "Ms Helpline" in the list of admins
    And I should not see "Micro Helpline" in the list of admins

  @selenium
  Scenario: persists what role has been selected across page refreshs
    Given mrhalp is a besk worker
    And I select "Besk Worker" from the list of roles
    When I refresh the page
    Then I should see "Micro Helpline" in the list of besk workers

  Scenario: add a user to a role
    Given I select "Besk Worker" from the list of roles
    When I add "mrhalp" to the selected role
    Then I should see "Micro Helpline" has been added to the list of besk workers
    And I should see the notice "Micro Helpline is now a BeskWorker"
    And the form to add users to a role should be reset

  Scenario: ensures users are not added to a role twice
    Given I select "Besk Worker" from the list of roles
    When I add "mrhalp" to the selected role
    And I add "mrhalp" to the selected role
    Then I should see the error "User is already in the selected role"

  Scenario: remove a user from a role
    Given mrhalp is a besk worker
    And I select "Besk Worker" from the list of roles
    When I remove "Micro Helpline" from the selected role
    Then I should see the notice "Micro Helpline is no longer a BeskWorker"

  @wip
  Scenario: filter results
    Given mrhalp is a besk worker
    And mshalp is a besk worker
    And I select "Besk Worker" from the list of roles
    When I search for "Micro Helpline" in the filter
    Then I should see "Micro Helpline" in the list of besk workers
    But I should not see "Ms Helpline" in the list of besk workers

  Scenario: can only be done by admins
    Given I am logged in with the email "worker@mit.edu"
    And I am a besk worker with the email "worker@mit.edu"
    When I am on the page to manage roles
    Then I should be redirected to the home page
    And I should not see the URL to manage roles
