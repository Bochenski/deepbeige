class PickANumber < Game
  
  attr_reader :winner, :move_list, :next_player
  attr_accessor :quiet, :verbose
  def initialize
    @position = {"1" => 0,"2" => 0, "3" => 0}
    @next_player = 0
    @move_list = []
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
  
  def show_board
    board = "Please Pick from the following Numbers:\n"

    @position.each do |move|
      if move[1] == 0
        board += "#{move[0]},"
      end  
    end
    board +"\n"
  end
  
  def play_move(player, move)
    unless player == @next_player
      display "not player #{player}'s turn"
      return false
    end
    unless @position[move] == 0
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
      @position[move] = 1
    else
      @position[move] = -1
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
      display @position
    end
    true      
  end
  
  def current_position
    return @position
  end
    
  def won?
    if @position["3"] != 0
      return true
    end
    false
  end
  
  def drawn?
    if @position["2"] != 0
      return true
    end
    false
  end
end