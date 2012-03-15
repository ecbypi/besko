@javascript @selenium
Feature: Mail received packages
  Given some packages arrived at besk
  In order to be a responsible besk worker
  I need to email the recipients of the packages

  Background:
    Given I am logged in with the email "responsable@mit.edu"
    And I am a besk worker with the email "responsable@mit.edu"
    And the following users exist:
      | First Name | Last Name | Login | Email                 |
      | Jon        | Snow      | snow  | snow@thewall.kingdom  |
      | Arya       | Stark     | boy   | boy@kingsroad.kingdom |

  Scenario Outline: Search for recipients by name, email or login (kerberos)
    Given I am on the page to log deliveries
    When I search for "<search>"
    Then I should see "Jon Snow" in the autocomplete list

    Examples:
      | search               |
      | Jon Snow             |
      | snow@thewall.kingdom |
      | snow                 |

  Scenario: Add a recipient
    Given I am on the page to log deliveries
    When I search for "Jon Snow"
    And I click on "Jon Snow" in the autocomplete list
    Then I should see a receipt form for "Jon Snow"
    And I should not see "Jon Snow" in the autocomplete form

  Scenario: Send notifications
    Given I am on the page to log deliveries
    When I specify the delivery is from "FedEx"
    And I add "Jon Snow" to the list of recipient receipts
    And I specify "Jon Snow" received 2 packages
    And I add the comment "Fragile" to "Jon Snow"'s delivery receipt
    And I submit the notifications
    Then I should see the notice "Notifications Sent"
    And I visit the deliveries page
    And I should see the delivery was by "FedEx"
    And a delivery notification should be sent to "snow@thewall.kingdom"
