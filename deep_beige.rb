require_relative 'noughts_and_crosses'
require_relative 'neural_net'
require 'uuid'
class DeepBeige
  attr_reader :id
  def initialize
    p "Deep Beige is feeling tired."
    @neural_net = NeuralNet.new 9, 1, 3
    @id = UUID.new
  end
  
  def get_move position, moves
    game = NoughtsAndCrosses.new
    game.reload_position moves
    
    best_move = ""
    best_score = -2
    game.legal_moves.each do |move|
      @neural_net.input = game.current_position.values
      @neural_net.evaluate
      score = @neural_net.output_value
      if score > best_score
        best_score = score
        best_move = move
      end
    end
    best_move
  end
end


