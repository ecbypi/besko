@javascript
Feature: Create an account
  In order to use the site
  As an interested resident of the dorm
  I need to request an account

  Scenario: Create account by search
    Given I am on the sign up page
    When I search for "Micro Helpline" in the user search
    And I select "Micro Helpline" in the user search results
    Then I should see the notice "Your account has been submitted for approval"
    And the search should be reset
    And an account confirmation email should be sent to "besko@mit.edu"
    And the email should include the user's name "Micro Helpline"
    And the email should include the user's email "mrhalp@mit.edu"
    And the email should include the user's kerberos "mrhalp"

  Scenario: Searching for an existing account
    Given the following user exists:
      | First Name | Last Name | Email          | Login  |
      | Micro      | Helpline  | mrhalp@mit.edu | mrhalp |
    And I am on the sign up page
    When I search for "Micro Helpline" in the user search
    Then I should see that an account for "Micro Helpline" already exists
