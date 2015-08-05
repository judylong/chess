require_relative :board

class Game
  attr_reader :board

  def initialize
    @board = Board.new
    @board.setup_pieces
  end

  def prompt
  end

  def play

  end

end
