@javascript
Feature: Navigate Deliveries
  In order to assist with missing packages or prevent duplicate notifications
  As a besk worker
  I need to view delivery receipts in the past

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
