#A match is a series of games between players
require_relative 'noughts_and_crosses'

class Match
  def initialize players, first_to
    @players = players
    @first_to = first_to
    @player_wins = {0}
  end
  
  def play_match
   until leading_player[1] >= first_to
    game = NoughtsAndCrosses.new
    table = Table.new game, players
    table.play_game
    if game.winner
      @player_wins[@players[@winner]] += 1
    end
   end
  end
  
  def result
  end
private 
  def leading_player
    @player_wins.sort_by({|player, count| count}).first
  end
end