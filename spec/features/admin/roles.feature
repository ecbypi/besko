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
  Scenario Outline: add a user to a role
    Given I select "Besk Worker" from the list of roles
    When I add "<user>" to the selected role
    Then I should see "Micro Helpline" has been added to the list of besk workers
    And I should see the notice "Micro Helpline is now a Besk Worker"
    And the form to add users to a role should be reset

    Examples:
      | user           |
      | Micro Helpline |
      | mrhalp         |
      | mrhalp@mit.edu |
