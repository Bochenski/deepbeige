#A match is a series of games between players
require_relative 'noughts_and_crosses'
require_relative 'table'
require 'uuid'
class Match
  def initialize players, first_to
    @players = players
    @first_to = first_to
    @player_wins = {}
    players.each do |player|
      @player_wins[player.id] = 0
    end
  end
  
  def play
   while leading_player[1] < @first_to 
    game = NoughtsAndCrosses.new
    table = Table.new game, @players
    table.play_game
    if game.winner
      @player_wins[@players[game.winner].id] += 1
      p "#{game.winner} won that game and has #{ @player_wins[@players[game.winner].id] } wins"
      p "leading player is #{leading_player[0]} with #{leading_player[1]} wins"
    end
    gets
   end
  end
  
  def result
  end
  
private 
  def leading_player
    leaderboard =  @player_wins.sort_by {|id, count| count}
    leaderboard.last
  end
end