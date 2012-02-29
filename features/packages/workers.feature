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

  Scenario: View today's packages
    Given the following package was received today by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment         |
      | USPS         | In your mailbox |
    When I visit the worker packages page
    Then I should the package was received by "Besk Worker" and a link to email them at "besker@mit.edu"
    And I should see the package was sent to "Micro Helpline"
    And I should see the package's received-on timestamp for "today"
    Then I should see the package's details:
      | delivered_by | comment         |
      | USPS         | In your mailbox |

  Scenario: Navigate packages by previous day button
    Given the following package was received yesterday by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment |
      | UPS          | Heavy   |
    And I visit the worker packages page
    When I go to the previous day of packages
    Then I should see the package's received-on timestamp for "yesterday"

   Scenario: Navigate packages by next day button
    Given the following package was received tomorrow by "besker@mit.edu" for "mrhalp@mit.edu":
      | delivered_by | comment                               |
      | FedEx        | Some legal document.  Looks important |
    And I visit the worker packages page
    When I go to the next day of packages
    Then I should see the package's received-on timestamp for "tomorrow"
