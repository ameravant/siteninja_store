Feature: Manage videos for sale
  In order to manage videos for the video products page
  As an admin 
  I want to create and manage videos

  Scenario: List Video Products
    Given I have videos named Vacation and Greece Holiday
    When I go to the list of products
    Then I should see "Vacation"
    And I should see "Greece Holiday"

  
  

  
