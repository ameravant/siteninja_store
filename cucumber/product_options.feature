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
  | id | product_id | title              | price | available |
  | 1  | 100        | small-Blue-frizzy | 20    | true      |
  | 2  | 100        | med-Blue          | 25    | true      |
  | 3  | 100        | lrg-Blue          | 25    | false     |
  | 4  | 200        | red               | 12    | true      |
      

Scenario: Going to the listing of products
    Given I am on home page
    When I go to the list of products page
    Then I should see "Cool Shirt"
    And I should see "Neat Hat" 


Scenario Outline: Going to a product and selecting options
  Given I am on the list of products page
  When I visit product page for "Cool Shirt"
  And I select "<option>" from "options_option_id"
  Then I should <result>
  
  Examples:
    | option            | result   |
    | small-Blue-frizzy | see "20" |
    | med-Blue          | see "25" |
    | lrg-Blue          | see "25" |
