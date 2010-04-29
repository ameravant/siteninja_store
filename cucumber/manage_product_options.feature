Feature: Manage product options
  In order to manage product options
  As an admin
  I want to crud price options
  
  Background: 
    Given I am logged in as "admin" with password "admin"
    And the following product records
      | name       | id  |
      | Cool Shirt | 100 |
    
# Need some way to test jscript :-/ for this to work
# @focus    
#     Scenario: Fill in product options of a product
#       Given I am on admin products page
#       When I follow "Cool Shirt"
#       Then I should see "Edit Cool Shirt"
#       When I fill in the following:
#       |product_option_title|Red|
#       |product_option_price|22|
#       And I press "add product option"
#       Then I should see "Red"
#       And I should see 22
