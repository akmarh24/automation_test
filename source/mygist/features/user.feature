Feature: CRUD Gist

Background: user signin on gist
    Given user is on login page
    When login as user akmar
    Then user should be redirected to git dashboard page
	

Scenario: As a user, I want to create a public gist
	Given user on list gist page
	When user create new gist
	Then gist created

Scenario: As a user, I want to edit an existing gist
	Given user on list gist page
	When user edit gist
	Then gist name should be update

Scenario: As a user, I want to delete an existing gist
	Given user on list gist page
	When user deleted the gist
	Then success deleted gist

Scenario: As a user, I want to see my list of gists
	Given user on list gist page
	Then should be directed on list gist page

