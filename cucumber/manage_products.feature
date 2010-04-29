Feature: Manage products
  In order to Manage Products
  As an admin
  I want to crud products

  Background: 
    Given I am logged in as "admin" with password "admin"

    Scenario: Fill in product options of a product
      Given I am on admin products page
      When I follow "Create a new product"
      Then I should be on new product page
      And I should see fields labeled Title, Price
      When I fill in the following:
      | Title | New Great Product |
      | Price | 25.30             |
      And I press "Save Product"
      Then I should see "New Great Product Created"

  
