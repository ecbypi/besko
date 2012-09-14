@review_receipts
Feature: View Delivery Receipts
  In order to keep track of packages I'm expecting
  As a package recipient
  I want to review and sign out the packages received for me

  Background:
    Given I am logged in with the email "packy@mit.edu"
    And the following user exists:
      | First Name | Last Name | Email          |
      | Besk       | Worker    | besker@mit.edu |
    And the following delivery exists:
      | ID | Deliverer | worker                |
      | 1  | UPS       | email: besker@mit.edu |
    And the following receipt exists:
      | delivery_id | recipient            | comment | Created At | Number Packages |
      | 1           | email: packy@mit.edu | Fragile | 2010-10-30 | 5               |

  Scenario: See package receipts
    Given I am on the receipts page
    Then I should see a link to email "Besk Worker" at "besker@mit.edu"
    And I should see the receipt's details:
      | delivered_by | comment | received_on      | number_packages |
      | UPS          | Fragile | October 30, 2010 | 5               |
    And I should see a button to sign out the packages received by "Besk Worker"

  Scenario: Confirm packages in receipt
    Given I am on the receipts page
    When I sign out the packages received by "Besk Worker"
    Then I should see the notice "Package Signed Out"
    And I should not see the sign out button for that receipt

  Scenario: Users view only their own receipts
    Given I am logged in with the email "packy-roommate@mit.edu"
    And the following receipt exists:
      | recipient                     | Comment     | Created At | Number Packages |
      | email: packy-roommate@mit.edu | Smells good | 2010-10-31 | 8               |
    And I am on the receipts page
    Then I should see the receipt's details:
      | delivered_by | comment     | received_on      | number_packages |
      | FedEx        | Smells good | October 31, 2010 | 8               |
    But I should not see others' receipt details:
      | delivered_by | comment | received_on      | number_packages |
      | UPS          | Fragile | October 30, 2010 | 5               |

  Scenario: Allow access only to logged in users with packages
    Given I am logged in with the email "no-packages@mit.edu"
    When I am on the receipts page
    Then I should be redirected to the home page
    And I should not see the URL to review receipts
