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
      p "attempting play move #{move } with player #{@game.next_player}"
      @game.play_move @game.next_player, move
      puts @game.show_board
      puts @game.current_position
      p @game.move_list
      gets
    end
  end
end