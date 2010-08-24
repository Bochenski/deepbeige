#A Table is where players come to play a game (possibly as part of a match as part of a tournament if required)
#Essentially a Table is a Game Controller
class Table
  attr_reader :players, :games
  
  def initialize game, players
    @game = game
    @players = players
  end
  
  def play_game
    until @game.won? || @game.drawn?
      next_player = @players[@game.next_player]
      move = next_player.get_move @game.current_position, @game.move_list
      p "player #{@game.next_player} plays move #{move }"
      @game.play_move @game.next_player, move
      puts @game.show_board
    end
  end
end