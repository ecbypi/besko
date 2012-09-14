@touchstone
Feature: Login via touchstone

  Scenario: Touchstone button on the login page
    Given I am on the login page
    When I look in the touchstone login form
    Then I should see a button to login via touchstone

