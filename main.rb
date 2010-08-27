#!/usr/bin/env ruby
require_relative 'noughts_and_crosses'
require_relative 'deep_beige'
require_relative 'match'

#Generate a Game
game = NoughtsAndCrosses.new

#Generate Players
player1 = DeepBeige.new
player2 = DeepBeige.new
players = [player1, player2]

#Create a Match
match = Match.new players, 5

#Play the Match
match.play

