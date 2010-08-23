#!/usr/bin/env ruby
require_relative 'noughts_and_crosses'
require_relative 'neural_net'

puts "Deep Beige is feeling cross."
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
player1 = NeuralNet.new 9, 1, 3
player2 = NeuralNet.new 9, 1, 3
player3 = NeuralNet.new 9, 1, 3
player1.input =  [0,0,0,0,0,0,0,0,0]
player1.evaluate
p "Player 1 evaluated position to be worth: #{player1.output_value}"
player2.input = [1,0,0,-1,-1,0,0,1,0]
player2.evaluate
player3.input = [1,0,0,-1,-1,0,0,1,0]
player3.evaluate
p "Player 2 evaluated position to be worth: #{player2.output_value}"
p "Player 3 evaluated position to be worth: #{player3.output_value}"
#for each legal move, ask the current player to evaluate it
best_move = ""
best_score = 0
game.legal_moves.each do |move|

end
