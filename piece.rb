require 'colorize'

class Piece
  attr_accessor :pos, :board, :color

  def initialize(pos = nil, board = nil, color = nil)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
    positions = []
#self.class::
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

  def to_s
    piece = self.class.to_s[0..1]
    self.color == :W ? piece.red : piece.black
  end
end

class SlidingPiece < Piece
  def potential_moves(delta)
    moves = []

    until !valid_pos?(move = next_pos(pos, delta))
      moves << move
    end

    moves
  end
end

class SteppingPiece < Piece
  def potential_moves(delta)
    [next_pos(pos, delta)]
  end
end

class Knight < SteppingPiece
  DELTAS = [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
  ]

end

class King < SteppingPiece
  DELTAS = [
    [ 1,  1],
    [ 1,  0],
    [ 1, -1],
    [ 0, -1],
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 1,  0],
  ]
end

class Bishop < SlidingPiece
  DELTAS = [
    [ 1,  1],
    [ 1, -1],
    [-1, -1],
    [-1,  1],
  ]
end

class Rook < SlidingPiece
  DELTAS = [
    [ 1,  0],
    [ 0, -1],
    [-1,  0],
    [ 1,  0],
  ]
end

class Queen < SlidingPiece
  DELTAS = [
    [ 1,  1],
    [ 1,  0],
    [ 1, -1],
    [ 0, -1],
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 1,  0],
  ]
end
