require 'colorize'
require 'byebug'

class Piece
  attr_accessor :pos, :board, :color

  def initialize(pos = nil, board = nil, color = nil)
    @pos = pos
    @board = board
    @color = color
  end

  def moves
    positions = []

    self.class::DELTAS.each do |delta|
      p delta
      possible_moves = potential_moves(delta)
      positions.concat(possible_moves) unless possible_moves.nil?
    end

    positions
  end

  def next_pos(pos, delta)
    x, y = pos
    dx, dy = delta

    [x + dx, y + dy]
  end

  def valid_pos?(pos)
    board.on_board?(pos) && (board[pos].nil? || board[pos].color != color)
  end

  def to_s
    piece = self.class.to_s[0..1]
    self.color == :W ? piece.red : piece.black
  end
end

class Pawn < Piece
  attr_accessor :first_move

  def initialize(pos, board, nil)
    super
    @first_move = true
  end

  def first_move?
    first_move
  end
end


class SlidingPiece < Piece
  def potential_moves(delta)
    moves = []

    current_pos = pos

    until !valid_pos?(move = next_pos(current_pos, delta))
      moves << move
      current_pos = move
    end

    moves
  end
end

class SteppingPiece < Piece
  def potential_moves(delta)
    move = next_pos(pos, delta)
    [move] if valid_pos?(move)
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
    [ 0,  1],
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
    [ 0,  1],
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
    [ 0,  1],
  ]
end
