Feature: Manage Package Notifications
  In order to effectively send and check package notifications
  As a besk worker
  I want to review all package notifcations and create new ones

  Background:
    Given I am logged in with the email "worker@mit.edu"
    And I am a besk worker with the email "worker@mit.edu"
    And the following users exist:
      | First Name | Last Name | Email          |
      | Micro      | Helpline  | mrhalp@mit.edu |
      | Besk       | Worker    | besker@mit.edu |

  Scenario: View today's deliveries
    Given the following delivery exists:
      | Deliverer | worker                |
      | USPS      | email: besker@mit.edu |
    When I visit the deliveries page
    Then I should see a link to email "Besk Worker" at "besker@mit.edu"
    And I should see the delivery's received-on timestamp for "today"
    And I should see the delivery was by "USPS"

    @wip
  Scenario: Navigate deliveries by previous day button
    Given 3 packages were received yesterday by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment |
      | UPS          | Heavy   |
    And I visit the deliveries page
    When I go to the previous day of deliveries
    Then I should see the delivery's received-on timestamp for "yesterday"

    @wip
   Scenario: Navigate deliveries by next day button
    Given 3 packages were received tomorrow by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment                               |
      | FedEx        | Some legal document.  Looks important |
    And I visit the deliveries page
    When I go to the next day of deliveries
    Then I should see the delivery's received-on timestamp for "tomorrow"
