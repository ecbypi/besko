@passwords
Feature: Reset Passwords
  In order for forgetful and auto-generated users to login
  As an administrator
  I need to let users reset their password

  Background:
    Given a user exists with an email of "forgetful@mit.edu"

  Scenario: Request password reset
    Given I am on the page to request a password reset
    When I submit the email "forgetful@mit.edu" for a password reset
    Then I should be on the login page
    And I should see the notice "You will receive an email with instructions about how to reset your password in a few minutes."
    And an email with password reset instructions should be sent to "forgetful@mit.edu"

  Scenario: Reset password
    Given I requested a password reset for "forgetful@mit.edu"
    And I visit the url from the email I was sent at "forgetful@mit.edu"
    When I submit a new password "safepass"
    Then I should be on the home page
    And I should see the notice "Your password was changed successfully. You are now signed in."
