#!/usr/bin/env ruby
require_relative 'noughts_and_crosses'
require_relative 'deep_beige'
require_relative 'match'
require_relative 'human'

version = "0.0.1"

def play_against_population name
  #ok so now I'm interested in playing my best creation
  db = DeepBeige.new 
  db.load_from_file "#{name}/best.txt"
  me = Human.new
  play_noughts_and_crosses me, db, []
end

def play_human_vs_human 
  p1 = Human.new
  p2 = Human.new
  play_noughts_and_crosses p1,p2, []
end

def play_noughts_and_crosses p1, p2, options
  players = [p1,p2]
  game = NoughtsAndCrosses.new
  table = Table.new game, players
  
  options.each do |option|
    if option == "verbose"
      game.verbose = true
    elsif option == "quiet"
      game.quiet = true
      table.quiet = true
    end
  end

  table.play_game
end

def load_population name
  population = []
  Dir["#{name}/*[0-9].txt"].each do |filename|
   candidate = DeepBeige.new
   candidate.load_from_file filename
   population << candidate
  end
  population
end

def save_population name, population
  #and at the end of that, we ought to save our population
  i = 0
  population.each do |player|
    player.save_to_file "#{name}/#{i}.txt"
    i += 1
  end
end

def generate_population size,name
  #Generate Population
  unless FileTest::directory?(name)
    Dir::mkdir(name)
  end
  population = []
  scores = {}
  size.times do 
    player = DeepBeige.new
    population << player
  end
  save_population name, population
end


def evolve_existing_population name, generations
  
  population = load_population name
  scores = {}
  population.each do |player|
    scores[player.id] = 0
  end
  generation_number = 1
  generations.times do
    puts "Evolving Generation #{generation_number}"

    population.each do |player|
      5.times do
        game = NoughtsAndCrosses.new
        game.quiet = false
        opponent_number = rand(population.count)
        puts "#{player.id} versus opponent #{opponent_number}"
        opponent = population[opponent_number]
        
        players = [player,opponent]
        table = Table.new game, players
        table.quiet = true
        table.play_game
        if game.drawn?
          puts "draw"
          players.each do |player|
            scores[player.id] +=1
          end
          
        elsif game.won?
          puts "#{game.winner} won"
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
      leaderboard =  scores.sort_by {|id, count| count}
      position = 1
      5.times do 
        leader = leaderboard[leaderboard.count - position]
        puts "#{position}. pts: #{leader[1]}, #{leader[0]}"
        position +=1
      end
    end 
    leaderboard =  scores.sort_by {|id, count| count}
    population.each do |player|
      if player.id == leaderboard.last[0]
        player.save_to_file "#{name}/best.txt"
      end
    end
    i = 0
    while i < 15 do
      population.delete_if {|player| player.id == leaderboard[i][0]}
      i +=1
    end

    new_players = []
    population.each do |player|
      new_player = player.clone
      new_player.mutate
      new_players << new_player
    end
    population.concat new_players

    scores = {}
    population.each do |player|
      scores[player.id] = 0 
    end
    
    generation_number +=1
  end
  
  save_population name, population
end

def options
  puts
  puts "What would you like to do?"
  puts "  1. Play Against Population"
  puts "  2. Evolve Existing Population"
  puts "  3. Generate New Population"
  puts "  4. Play Human v Human"
  puts "  5. Exit"
end

#This is the main execution loop of our program
puts
puts "Welcome to DeepBeige v#{version}"
exit = false
until exit do
  options
  input = gets.chop
  if input == "1"
    puts "Which Population?"
    name = gets.chop
    play_against_population name
  elsif input == "2"
    puts "Which Population?"
    name = gets.chop
    puts "How Many Generations?"
    generations = gets.chop.to_i
    evolve_existing_population name, generations
  elsif input == "3"
    puts "Please Enter Desired Population Size?"
    size = gets.chop.to_i
    puts "Please Give your Population a Name"
    name = gets.chop
    generate_population size, name
    puts "Population #{name} generated sucessfully"
  elsif input == "4"
    play_human_vs_human
  elsif input == "5"
    puts "Bye Bye"
    exit = true
  else 
    puts "Sorry I didn't understand you"
  end
end










