require_relative 'player'

class Human < Player
  def initialize game
    @game = game
  end
    
  def get_move position, moves
    game = @game.class.new
    game.reload_position moves
    print game.show_board
    move = gets.chop
  end
end