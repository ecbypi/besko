Feature: Log in Users
  In order use the website
  As a user
  I want login

  Scenario: Successful Login using Email Address
    Given I have an approved user account
    When I submit my email and password on the login page
    Then I should see the root page
    And I should see the notice "Login Successful"

  Scenario: Successful Login using Login
    Given I have an approved user account
    When I submit my login and password on the login page
    Then I should see the root page

  Scenario: Unapproved Account
    Given I have an unapproved user account
    When I submit my login and password on the login page
    Then I should see the login page
    And I should see the error "Your account has not been approved"

  Scenario: Invalid Login or Password
    Given I am on the login page
    When I submit an incorrect login and password
    Then I should see the login page
    And I should see the error "Invalid credentials"
