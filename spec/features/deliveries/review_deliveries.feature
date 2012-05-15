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
      | Ms         | Helpline  | mshalp@mit.edu |

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

  Scenario: View receipts for a delivery
    Given the following delivery exists:
      | ID | Deliverer | worker                |
      | 1  | FedEx     | email: besker@mit.edu |
    And the following receipts exist:
      | Delivery ID | Comment         | Number Packages | recipient             |
      | 1           | Big packages    | 3345            | email: mrhalp@mit.edu |
      | 1           | Bigger packages | 3346            | email: mshalp@mit.edu |
    And I visit the deliveries page
    When I click on the delivery from FedEx, received by "Besk Worker"
    Then I should see that "Micro Helpline" received 3345 packages with the comment "Big packages"
    And I should see that "Ms Helpline" received 3346 packages with the comment "Bigger packages"

  Scenario: Authorize access to besk workers only
    Given I am logged in with the email "just-a-resident@mit.edu"
    When I visit the deliveries page
    Then I should be redirected to the home page
    And I should not see the URL to review deliveries
