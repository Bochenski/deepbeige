require 'uuid'
class DeepBeige

  attr_accessor :id
  
  def initialize
    @neural_net = NeuralNet.new 9, 1, 3
    @id = UUID.new.to_s.split(':')[1].chop
    @population =[]
  end
  
  def load_game game_name
    case game_name
    when "Noughts and Crosses"
    when "Pick a Number"
    else
    end
  end
  
  def get_move position, moves,
    game = NoughtsAndCrosses.new
    game.quiet = true
    game.reload_position moves
    
    best_move = ""
    best_score = -2
    game.legal_moves.each do |move|
      game2 = NoughtsAndCrosses.new
      game2.quiet = true
      game2.reload_position moves
      game2.play_move game.next_player, move
      @neural_net.input = game2.current_position.values
      @neural_net.evaluate
      score = @neural_net.output_value
      if game.next_player == 0
        score = -score
      end
      #p "move #{move} evaluated as #{score}"
      if score > best_score
        best_score = score
        best_move = move
      end
    end
    best_move
  end

  def train
    
  end
  
  def load_from_file file
    fingerprint = []
    File.open(file, 'r') do |f|
      @id = f.gets.chop
      while line = f.gets do
        fingerprint << line
      end
    end
    @neural_net.reload fingerprint
  end
  
  def save_to_file file
    File.open(file, 'w')  do |f|
       f.puts id
       f.write(@neural_net.fingerprint) 
    end
  end
  
protected
  def neural_net= neural_net
    @neural_net = neural_net
  end
  
private 
  def mutate
    @neural_net.mutate
  end

  def clone
    clone = DeepBeige.new
    clone.neural_net = @neural_net.clone
    clone
  end
end


