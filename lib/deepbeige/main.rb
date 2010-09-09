require 'rubygems'
require 'game'
require 'pick_a_number'
require 'noughts_and_crosses'
require 'human'
require 'deepbeige'
require 'table'

$application_name = "DeepBeige"
      
class DeepBeige
  class Main
    class << self
      def play_game game, p1, p2, options
        players = [p1,p2]
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

      def player_vs_deepbeige db, game
        #ok so now I'm interested in playing my best creation
        db.start_game game.name
        me = Human.new game
        if which_player == "1"
          play_game game, me, db, []
        else
          play_game game, db, me, []
        end
      end

      def player_vs_player game
        p1 = Human.new game
        p2 = Human.new game
        play_game game, p1,p2, []
      end

      def which_player
        puts
        puts "Would you like to be player 1 or 2?"
        gets.chop
      end

      def options
        puts
        puts "What would you like to do?"
        puts "  1. Player vs DeepBeige"
        puts "  2. Train DeepBeige"
        puts "  3. Reset DeepBeige"
        puts "  4. Player vs Player"
        puts "  5. Exit Application"
      end

      def game_choice
        puts
        puts "Which Game?"
        puts "  1. Noughts and Crosses"
        puts "  2. Pick A Number"
        game = nil
        case gets.chop
        when "1"
          game = NoughtsAndCrosses.new
        when "2"
          game = PickANumber.new  
        else 
          puts "Sorry, didn't understand you there."
        end
        game
      end
      
      def run!(*arguments)

 #       begin
          db = DeepBeige.new

          version = "0.2.2"
          puts
          puts "Welcome to DeepBeige v#{version}"

          exit = false
          until exit do
            options
            case input = gets.chop
            when "1"
              game =  game_choice
              player_vs_deepbeige db, game
            when "2"
              game = game_choice
              puts "How Many Generations?"
              generations = gets.chop.to_i
              db.train generations, game
            when "3"
              game = game_choice
              db.learn game
              puts "DeepBeige Reset sucessfully"
            when "4"
              game = game_choice
              player_vs_player game
            when "5"
              puts "Bye Bye"
              exit = true
            else 
              puts "Sorry I didn't understand you"
            end
          end
          return 0
#        rescue 
#          $stderr.puts "Something Went Wrong With Deep Beige - Sorry"
#          return 1
#        end
      end
    end
  end
end