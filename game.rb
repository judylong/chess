require_relative :board

class Game
  attr_reader :board, :current_player

  def initialize
    @board = Board.new
    @board.setup_pieces
    @current_player = :W
  end

  def play
    until board.checkmate?(current_player)
      board.render
      board.move(*get_move)
      switch_player
    end

    board.render
    switch_player
    puts "Game over! #{current_player} wins!"
  end

  def prompt
  end
end
