class Game
  
  def initialize
  end
  
  def display message
    unless @quiet
      p message
    end
  end
  
  def reload_position moves
    moves.each do |player, move|
      self.play_move player, move
    end
  end
  
end
