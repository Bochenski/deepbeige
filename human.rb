require_relative 'player'

class Human < Player
  def initialize
  end
    
  def get_move position, moves
    game = NoughtsAndCrosses.new
    game.reload_position moves
    print game.show_board
    move = gets.chop
  end
end