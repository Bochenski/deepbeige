#!/usr/bin/env ruby
require_relative 'noughts_and_crosses'
require_relative 'neural_net'

puts "Deep Beige is feeling noughty."
game = NoughtsAndCrosses.new
game.show_board
game.play_move 1, :B2
print game.show_board
game.play_move 1, :B2
print game.show_board
game.play_move 2, :A3
print game.show_board
game.play_move 1, :A2
print game.show_board
game.play_move 2, :C3
print game.show_board
game.play_move 1, :C2
print game.show_board
game.play_move 2, :A1

#Generate two players
player1 = NeuralNet.new
player2 = NeuralNet.new

#for each legal move, ask the current player to evaluate it
best_move = ""
best_score = 0
game.legal_moves.each do |move|
  
end
