Feature: Welcome
  In order to read the page
  As a viewer
  I want to see the home page of my app

  Background:
#    Given an ent_page named 'homepage'

  Scenario: View welcome page
    Given I am on the home page
#    And I open the page (debug)
    Then I should see "Welcome#index"