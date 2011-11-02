Feature: Manage Package Notifications
  In order to effectively send and check package notifications
  As a besk worker
  I want to review all package notifcations and create new ones

  Scenario: View today's packages
    Given I am a worker
    And there were 3 packages received today
    And I am logged in
    When I am on the worker packages page
    Then I should see a table with the packages received today

  Scenario: Navigate packages by next/previous day
    Given I am a worker
    And there were 3 packages received yesterday
    And I am logged in
    When I am on the worker packages page
    And I click the previous day button
    Then I should see a table with the packages received yesterday

   Scenario: Navigate packages by next day
    Given I am a worker
    And there were 3 packages received tomorrow
    And I am logged in
    When I am on the worker packages page
    And I click the next day button
    Then I should see a table with the packages received tomorrow
