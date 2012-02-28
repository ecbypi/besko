Feature: Log in Users
  In order use the website
  As a user
  I want login

  Scenario: Successful Login using Email Address
    Given a user exists with an email of "mrhalp@mit.edu"
    And I am on the login page
    When I submit the email and password "mrhalp@mit.edu" and "password"
    Then I should see the home page
    And I should see the notice "Signed in successfully."

  Scenario: Unapproved Account
    Given an unapproved user exists with an email of "mshalp@mit.edu"
    And I am on the login page
    When I submit the email and password "mshalp@mit.edu" and "password"
    Then I should see the login page
    And I should see the error "Your account needs to be confirmed before signing in."

  Scenario: Invalid Login or Password
    Given I am on the login page
    When I submit the email and password "blah@mit.edu" and "blahblahblah"
    Then I should see the login page
    And I should see the error "Invalid email or password."
