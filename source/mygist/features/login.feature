@login
Feature: Login to Git

	@smoketest
  Scenario: login as akmar
  	Given user is on login page
    When login as user akmar
    Then user should be redirected to git dashboard page
