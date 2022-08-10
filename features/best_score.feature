Feature: record the best score of a player

Scenario: guessed the correct word with 6 mistakes, then wins again with no mistakes

		Given I start a new game with word "peking"
		When I make the following guesses: a, b, c, d, f, h
		And I make the following guesses: p, e, k, i, n, g
		Then I should see "Your best run is 6 wrong guesses"

		Given I start a new game with word "book"
		And I should see "Best score: 6"
		When I make the following guesses: b, o, k
		Then I should see "Your best run is 0 wrong guesses"


