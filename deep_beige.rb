require 'neural_net'

class DeepBeige
  
  def initialize
    @neural_net = NeuralNet.new
    @population =[]
  end
  
  def id
    @neural_net.id
  end
  
  def start_game game_name
    @game_name = game_name
    case game_name
    when "NoughtsAndCrosses"
      @neural_net.generate 9, 1, 3
      @neural_net.load_from_file "DeepBeige/NoughtsAndCrosses/best.txt"
    when "PickANumber"
      @neural_net.generate 3,1,2
      @neural_net.load_from_file "DeepBeige/PickANumber/best.txt"
    end
  end
  
  def get_move position, moves
    game = game_from_name @game_name
    game.quiet = true
    game.reload_position moves
    
    best_move = ""
    best_score = -2
    game.legal_moves.each do |move|
      game2 = game_from_name @game_name
      game2.quiet = true
      game2.reload_position moves
      game2.play_move game.next_player, move
      input = game2.current_position.values
      
      if game.next_player == 1
        input = []
        game2.current_position.values.each do |value|
          input << -value
        end
      end
      
      @neural_net.input = input
      @neural_net.evaluate
      score = @neural_net.output_value
      #p "move #{move} evaluated as #{score}"
      if score > best_score
        best_score = score
        best_move = move
      end
    end
    best_move
  end

  def learn game
    generate_population 30, game.name
  end

  def train generations, game 
    @game_name = game.name   
    @population = load_population game.name
    
    #reset scores
    scores = {}
    @population.each do |neuralnet|
      scores[neuralnet.id] = 0
    end
    
    generation_number = 1
    generations.times do
      puts "Evolving Generation #{generation_number}"
      player_number = 0
      @population.each do |neuralnet|
        player1 = DeepBeige.new 
        player1.neural_net = neuralnet
        player1.game_name = @game_name
        
        5.times do
          game = game.class.new
          game.quiet = true
          opponent_number = rand(@population.count)
          #puts "#{player_number} versus opponent #{opponent_number}"
          opponent_net = @population[opponent_number]
          player2 = DeepBeige.new
          player2.neural_net = opponent_net
          player2.game_name = @game_name
          
          players = [player1,player2]
          table = Table.new game, players
          table.quiet = true
          table.play_game
          if game.drawn?
            players.each do |player|
              scores[player.id] +=1
            end

          elsif game.won?
            winner = players[game.winner]
            players.each do |player|
              if player.id == winner.id
                scores[player.id] +=2
              else
                scores[player.id] -=2
              end
            end
          end

        end
        player_number += 1
      end 
      leaderboard =  scores.sort_by {|id, count| count}
      position = 1
      5.times do 
        leader = leaderboard[leaderboard.count - position]
        puts "#{position}. pts: #{leader[1]}, #{leader[0]}"
        position +=1
      end
      @population.each do |neural_net|
        if neural_net.id == leaderboard.last[0]
          neural_net.save_to_file "DeepBeige/#{@game_name}/best.txt"
        end
      end
      i = 0
      while i < 15 do
        @population.delete_if {|neural_net| neural_net.id == leaderboard[i][0]}
        i +=1
      end

      new_nets = []
      @population.each do |neural_net|
        new_net = neural_net.clone
        new_net.mutate
        new_nets << new_net
      end
      @population.concat new_nets

      scores = {}
      @population.each do |neural_net|
        scores[neural_net.id] = 0 
      end

      generation_number +=1
    end

    save_population game.name
  end

protected
  def neural_net= value
    @neural_net = value
  end
  def game_name= value
    @game_name = value
  end
  
private   
  def game_from_name name
    game = nil
    case name
    when "NoughtsAndCrosses"
      game  = NoughtsAndCrosses.new
    when "PickANumber"
      game = PickANumber.new
    end
    game
  end
  
  def load_population name
    @population = []
    Dir["deepbeige/#{name}/*[0-9].txt"].each do |filename|
     candidate = NeuralNet.new
     candidate.load_from_file filename
     @population << candidate
    end
    @population
  end
  
  def save_population name
    #and at the end of that, we ought to save our population
    i = 0
    @population.each do |neural_net|
      neural_net.save_to_file "DeepBeige/#{name}/#{i}.txt"
      i += 1
    end
  end
  
  def generate_population size, name
    #Generate Population
    dir_name = "DeepBeige/#{name}"
    unless FileTest::directory?(dir_name)
      Dir::mkdir(dir_name)
    end
    @population = []
    scores = {}
    size.times do 
      neural_net = NeuralNet.new
      case name
      when "NoughtsAndCrosses"
        neural_net.generate 9,1,3
      when "PickANumber"
        neural_net.generate 3,1,2
      end
      @population << neural_net
    end
    save_population name
  end
end


