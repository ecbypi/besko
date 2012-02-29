Feature: Manage Received Packages
  In order to keep track of packages I'm expecting
  As a package recipient
  I want to review and see a list of packages received for me

  Background:
    Given I am logged in with the email "packy@mit.edu"
    And the following user exists:
      | First Name | Last Name | Email          |
      | Besk       | Worker    | besker@mit.edu |
    And the following packages exist:
      | recipient            | worker                | delivered_by | comment | created_at |
      | email: packy@mit.edu | email: besker@mit.edu | UPS          | Fragile | 2010-10-30 |

  Scenario: See Received Packages
    Given I am on the packages page for recipients
    Then I should the package was received by "Besk Worker" and a link to email them at "besker@mit.edu"
    And I should see the package's details:
      | delivered_by | comment | received_on      |
      | UPS          | Fragile | October 30, 2010 |
    And I should see a button to sign out the package

  Scenario: Signing out a package
    Given I am on the packages page for recipients
    When I sign out the package received by "Besk Worker"
    Then I should see the notice "Package Signed Out"
    And I should not see the sign out button for that package
