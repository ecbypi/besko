@javascript @deliveries
Feature: Logging deliveries
  In order to notify recipients they have a delivery
  As a besk worker
  I need to email the recipients in an easy way

  Background:
    Given I am logged in with the email "responsable@mit.edu"
    And I am a besk worker with the email "responsable@mit.edu"
    And the following users exist:
      | First Name | Last Name | Login | Email                 |
      | Jon        | Snow      | snow  | snow@thewall.kingdom  |
    And mrhalp exists in the LDAP server

  Scenario: Add a recipient
    Given I am on the page to log deliveries
    When I search for "Jon Snow"
    And I click on "Jon Snow" in the autocomplete list
    Then I should see a receipt form for "Jon Snow"

  Scenario: Add recipients from LDAP
    Given I am on the page to log deliveries
    When I search for "mrhalp"
    And I click on "Micro Helpline" in the autocomplete list
    Then I should see a receipt form for "Micro Helpline"
    And no email should be sent

  Scenario: Send notifications
    Given I am on the page to log deliveries
    When I specify the delivery is from "FedEx"
    And I add "Jon Snow" to the list of recipient receipts
    And I specify "Jon Snow" received 2 packages
    And I add the comment "Fragile" to "Jon Snow"'s delivery receipt
    And I submit the notifications
    Then I should see the notice "Notifications Sent"
    And the delivery from should be reset
    And I visit the deliveries page
    And I should see the delivery was by "FedEx"
    And a delivery notification should be sent to "snow@thewall.kingdom"

  Scenario: Ensure only besk workers can create deliveries
    Given I am logged in with the email "just-a-resident@mit.edu"
    When I am on the page to log deliveries
    Then I should be redirected to the home page
    And I should not see the URL to create deliveries
