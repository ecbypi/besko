@javascript @deliveries
Feature: Navigate Deliveries
  In order to assist with missing packages or prevent duplicate notifications
  As a besk worker
  I need to view delivery receipts in the past

  Background:
    Given I am logged in with the email "worker@mit.edu"
    And I am a besk worker with the email "worker@mit.edu"
    And the following users exist:
      | First Name | Last Name | Email          |
      | Micro      | Helpline  | mrhalp@mit.edu |
      | Besk       | Worker    | besker@mit.edu |

  Scenario: Navigate deliveries by previous day button
    Given packages were received yesterday by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment |
      | UPS          | Heavy   |
    And I visit the deliveries page
    When I go to the previous day of deliveries
    Then I should see the delivery was by "UPS"

  Scenario: Navigate deliveries by next day button
    Given packages were received tomorrow by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment                               |
      | FedEx        | Some legal document.  Looks important |
    And I visit the deliveries page
    When I go to the next day of deliveries
    Then I should see the delivery was by "FedEx"

  @selenium
  Scenario: Navigate deliveries by picking date
    Given the following delivery exists:
      | Deliverer | Delivered On | Created At | worker                |
      | LaserShip | 2010-10-30   | 2010-10-30 | email: besker@mit.edu |
    And I visit the deliveries page
    When I navigate to view the deliveries delivered on "2010-10-30"
    Then I should see the delivery was by "LaserShip"
    And I should see the date "Saturday, October 30, 2010"

