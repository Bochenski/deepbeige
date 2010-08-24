#!/usr/bin/env ruby
require_relative 'noughts_and_crosses'
require_relative 'deep_beige'
require_relative 'table'

#Generate a Game
game = NoughtsAndCrosses.new

#Generate Players
player1 = DeepBeige.new
player2 = DeepBeige.new
players = [player1, player2]

#Find a Table
table = Table.new game, players

#Play the game
table.play_game
