class Piece
  attr_reader :board, :color
  attr_accessor :pos

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
    positions = []

    DELTAS.each do |delta|
      positions.concat(potential_moves(delta))
    end

    positions
  end

  def next_pos(pos, delta)
    x, y = pos
    dx, dy = delta

    [x + dx, y + dy]
  end

  def valid_pos?(pos)
    board[pos].color != color && board.on_board?(pos)
  end
end

def SlidingPiece < Piece
  def potential_moves(delta)
    moves = []

    until !valid_pos?(move = next_pos(pos, delta))
      moves << move
    end

    moves
  end
end

def SteppingPiece < Piece
  def potential_moves(delta)
    [next_pos(pos, delta)]
  end
end

def Knight < SteppingPiece
  DELTA
end

def King < SteppingPiece

end

def Bishop < SlidingPiece

end

def Rook < SlidingPiece

end

def Queen < SlidingPiece

end
