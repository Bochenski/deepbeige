require 'game'
class NoughtsAndCrosses < Game
  
  attr_reader :winner, :move_list, :next_player
  attr_accessor :quiet, :verbose
  def initialize
    @position = {A1: 0, B1: 0, C1: 0, A2: 0, B2: 0, C2: 0, A3: 0, B3: 0, C3: 0}
    @next_player = 0
    @move_list = []
  end

  def name
    "NoughtsAndCrosses"
  end
  
  def show_board
    board = " - - - \n"
    i = 0
    @position.each do |move|
      i += 1   
      board += "|"
      if move[1] == 0
        board += " "
      elsif move[1] == 1
        board += "X"
      else
        board += "O"
      end  

      if i == 3
        board += "|\n _ _ _\n"
        i = 0
      end   

    end
    board
  end
  
  def legal_moves
    legal_moves = []
    @position.each do |move|
      if move[1] == 0
        legal_moves << move[0].to_s
      end
    end
    legal_moves
  end
  
  def play_move(player, move)
    sym_move = move.to_sym
    unless player == @next_player
      display "not player #{player}'s turn"
      return false
    end
    unless @position[sym_move] == 0
      display "illegal move by player #{player}"
      return false
    end
    if won?
      display "player #{winner} has already won"
      return false
    elsif drawn?
      display "game was drawn"
      return false
    end

    @move_list << [player,move]
    
    if player == 1
      @position[sym_move] = 1
    else
      @position[sym_move] = -1
    end
    if won?
      display "player #{player} wins!"
      @winner = player
    elsif drawn?
      display "game drawn"
    end
    
    if @next_player == 1
      @next_player = 0
    else
      @next_player = 1
    end
    if @verbose
      display show_board
      display @position
    end
    true      
  end
  
  def current_position
    return @position
  end
    
  def won?
    if @position[:A1] != 0
      if @position[:A1] == @position[:A2] && @position[:A2] == @position[:A3]
        return true
      elsif @position[:A1] == @position[:B2] && @position[:B2] == @position[:C3]
        return true
      elsif @position[:A1] == @position[:B1] && @position[:B1] == @position[:C1]
        return true
      end
    end
    if @position[:B1] != 0
      if @position[:B1] == @position[:B2] && @position[:B2] == @position[:B3]
        return true
      end
    end
    if @position[:C1] != 0
      if @position[:C1] == @position[:C2] && @position[:C2] == @position[:C3]
        return true
      elsif @position[:C1] == @position[:B2] && @position[:B2] == @position[:A3]
        return true
      end
    end
    if @position[:A2] != 0
      if @position[:A2] == @position[:B2] && @position[:B2] == @position[:C2]
        return true
      end
    end
    if @position[:A3] != 0
      if @position[:A3] == @position[:B3] && @position[:B3] == @position[:C3]
        return true
      end
    end
    false
  end
  
  def drawn?
    unless legal_moves.count == 0
      return false
    end
    if won?
      return false
    end
    true
  end
end