@focus
Feature: select options for product
    In order to add a product to my cart with options
    As an anonymous user
    I want to choose from a list of options

Background:
    Given the following product records
      | name       | id  |
      | Cool Shirt | 100 |
      | Neat Hat   | 200 |


    Given the following product_option records
   | id | product_id | name              | price | available |
   | 1  | 100        | small-Blue-frizzy | 20    | true      |
   | 2  | 100        | med-Blue          | 21    | true      |
   | 3  | 100        | lrg-Blue          | 21    | false     |
   | 4  | 200        | red               | 12    | true      |
      

Scenario: Going to the product page
    Given I am on the home page
    When I go to products page
    Then I should see "Cool Shirt" and "Neat Hat"
    




# Feature: Products need Product options
#   In order to add product options to products
#   As a client
#   I want to include product options for products 
# 
#   @focus
#   Scenario: Fill in product options of a product
#     Given I am logged in as "admin" with password "admin"
#     And I am on admin products page
#     When I follow "Create a new product"
#     Then I should be on new product page
#     And I fill in a
#     Then I should see "Product Options"
#   
#   
#   
