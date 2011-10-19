Feature: Manage Received Packages
  In order to keep track of packages I'm expecting
  As a package recipient
  I want to review and see a list of packages received for me

  Scenario: See Received Packages
    Given I am a user who has received packages
    And I am logged in
    When I am on the packages page for recipients
    Then I should see a table with all my packages

  Scenario: Signing out a package
    Given I am a user who has received packages
    And I am logged in
    When I am on the packages page for recipients
    And I click the 'Sign Out' button for one of the packages
    Then I should see the notice "Signed out package"
    And the time the package was signed out at replaces the 'Sign Out' button
