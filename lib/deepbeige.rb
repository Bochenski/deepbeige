require 'neuralnet'

class DeepBeige
  
  def initialize
    @neural_net = nil
    @population =[]
  end
  
  def id
    @neural_net.id
  end
  
  def start_game game_name, options
    @game_name = game_name
    unless @neural_net
      @neural_net = NeuralNet.new
    end

    @neural_net.load_from_file (ENV["HOME"] + "/." + $application_name + "/#{(population_path(game_name, options))}/best.txt")
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

  def learn game, options
    size = 30
    
    if options[:size]
      size = options[:size]
    end
   
    generate_population size, game, options
  end

  def train generations, game, options
    @game_name = game.name   
    
    size = 30
    if options[:size]
      size = options[:size]
    end
    
    method = "GA"
    if options[:method]
      method = options[:method]
    end
    name = population_path game.name, options
    
    load_population name
    
    #reset scores
    scores = {}
    @population.each do |neural_net|
      scores[neural_net.id] = {:points => 0, :p1draws => 0, :p2draws => 0, :p1wins => 0, :p2wins => 0, :p1losses => 0, :p2losses => 0}
    end
    
    generation_number = 1
    generations.times do
      puts "Evolving Generation #{generation_number}"
      player_number = 0
      @population.each do |neural_net|
        player1 = DeepBeige.new 
        player1.neural_net = neural_net
        player1.game_name = game.name
        @population.each do |opponent_net|
          unless opponent_net.id == neural_net.id
            player2 = DeepBeige.new
            player2.neural_net = opponent_net
            player2.game_name = game.name
            play game.name, player1, player2, scores
          end
        end
        player_number += 1
      end 
      leaderboard =  scores.sort_by {|id, stats| stats[:points]}
      position = 1
      leaderboard.count.times do 
        leader = leaderboard[leaderboard.count - position]
        puts "#{position}. pts: #{leader[1][:points]}, #{leader[0]} | #{leader[1][:p1wins]}.#{leader[1][:p1losses]},#{leader[1][:p1draws]}| #{leader[1][:p2wins]}.#{leader[1][:p2losses]},#{leader[1][:p2draws]}"
        position +=1
      end
      @population.each do |neural_net|
        if neural_net.id == leaderboard.last[0]
          neural_net.save_to_file (ENV["HOME"] + "/." + $application_name + "/#{name}/best.txt")
        end
      end
      
      case method
      when "GA"
        i = 0
        number_to_cull = @population.count / 2
        while i < (number_to_cull) do
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
      when "SA"
        puts "culling with SA"
        @population.delete_if {|neural_net| neural_net.id != leaderboard.last[0]}
        unless @population.count == 1
          puts "ERROR with SA culling"
        end
        
        new_nets = []
        (size - 1).times do 
          new_net = @population[0].clone
          new_net.mutate
          new_nets << new_net
        end
        puts "culled population size: #{@population.count}"
        puts "new nets size: #{new_nets.count}"
        @population.concat new_nets  
      end
      scores = {}
      @population.each do |neural_net|
        scores[neural_net.id] = {:points => 0, :p1draws => 0, :p2draws => 0, :p1wins => 0, :p2wins => 0, :p1losses => 0, :p2losses => 0}
      end
      puts "population size: #{@population.count}"
      generation_number +=1
    end

    save_population name
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
    (Dir[ENV["HOME"] + "/." + $application_name + "/#{name}/*[0-9].txt"]).each do |filename|
     candidate = NeuralNet.new
     candidate.load_from_file filename
     @population << candidate
    end
    @population
  end
  
  def save_population name
    check_directories name
    #and at the end of that, we ought to save our population
    i = 0
    @population.each do |neural_net|

      neural_net.save_to_file (ENV["HOME"] + "/." + $application_name +"/#{name}/#{i}.txt")
      i += 1
    end
  end

  
  def generate_population size, game, options
    
    #Generate Population
    @population = []
    scores = {}
    size.times do 
      neural_net = NeuralNet.new
      case game.name
      when "NoughtsAndCrosses"
        neural_net.generate :inputs => 9, :outputs => 1, :tiers => 3
      when "PickANumber"
        neural_net.generate :inputs => 3, :outputs => 1, :tiers => 2
      end
      @population << neural_net
    end
    save_population (population_path game.name, options)
  end
  
private

  def population_path game_name, options
    name = game_name 
    method = "GA"
    if options[:population_name]
      population_name = options[:population_name]
      name = name + "/#{population_name}"
    end
    if options[:method]
      method = options[:method]
      name = name + "/#{method}"
    end
    name
  end
  
  def check_directories path
     #Check Directories Exist
      home_dir = ENV["HOME"] + "/." + $application_name
      unless FileTest::directory?(home_dir)
        Dir::mkdir(home_dir)
      end
      dir_name = home_dir
      path.split("/").each do |folder|
        dir_name = dir_name  +"/#{folder}"
        unless FileTest::directory?(dir_name)
          Dir::mkdir(dir_name)
        end
      end 
  end
  
  def play game_name, player1, player2, scores
    game = game_from_name game_name
    game.quiet = true

    #puts "#{player1.id} versus opponent #{player2.id}"
    players = [player1, player2]

    table = Table.new game, players
    table.quiet = true
    table.play_game
    if game.drawn?
      players.each do |player|
        scores[player.id][:points] +=0
        if player.id == player1.id
          scores[player.id][:p1draws] +=1
        else
          scores[player.id][:p2draws] +=1
        end
      end

    elsif game.won?
      winner = players[game.winner]
      players.each do |player|
        if player.id == winner.id
          scores[player.id][:points] +=0
          if player.id == player1.id
            scores[player.id][:p1wins] +=1
          else
            scores[player.id][:p2wins] +=1
          end
        else
          scores[player.id][:points] -= 1
          if player.id == player1.id
            scores[player.id][:p1losses] +=1
          else
            scores[player.id][:p2losses] +=1
          end
        end
      end
    end
  end
end


