Feature: User
  In order to login and crud users
  As a user
  I want to login and perform crud actions

  Scenario: Login to admin
    Given I am logged in as "admin" with password "admin"
    When I go to admin_path
    Then I should see "Signed in as admin admin"
  