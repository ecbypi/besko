@javascript @deliveries
Feature: Review Deliveries
  In order to effectively send and check delivery notifications
  As a besk worker
  I want to review all delivery notifcations

  Background:
    Given I am logged in with the email "worker@mit.edu"
    And I am a besk worker with the email "worker@mit.edu"
    And the following users exist:
      | First Name | Last Name | Email          |
      | Micro      | Helpline  | mrhalp@mit.edu |
      | Besk       | Worker    | besker@mit.edu |

  Scenario: View today's deliveries
    Given the following delivery exists:
      | ID | Deliverer | worker                |
      | 1  | USPS      | email: besker@mit.edu |
    And the following receipt exists:
      | Delivery ID | Comment | Number Packages |
      | 1           | Heavy!  | 545             |
    When I visit the deliveries page
    Then I should see today's date
    And I should see a link to email "Besk Worker" at "besker@mit.edu"
    And I should see the timestamp for the delivery from "USPS"
    And I should see a total package count of 545
    And I should see the delivery was by "USPS"

  Scenario: Authorize access to besk workers only
    Given I am logged in with the email "just-a-resident@mit.edu"
    When I visit the deliveries page
    Then I should be redirected to the home page
