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

    deltas.each do |delta|
      possible_moves = potential_moves(delta)
      positions.concat(possible_moves) unless possible_moves.nil?
    end

    positions
  end

  def update_piece(pos)
    self.pos = pos
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

  def deltas
    self.class::DELTAS
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

class Pawn < SteppingPiece
  DELTAS = [
    [1, -1], #capture
    [1,  1], #capture
    [2,  0], #first move
    [1,  0] #anytime
  ]

  attr_accessor :first_move

  def initialize(pos, board, color)
    super
    @first_move = true
  end

  def first_move?
    first_move
  end

  def valid_pos?(new_pos)
    return false unless board.on_board?(new_pos)
    if new_pos[1] != pos[1] #capture move
      return false if board[new_pos].nil? || board[new_pos].color == color
    elsif new_pos[0] == pos[0] + 2
      return false unless first_move?
      return false if !board[new_pos].nil? ||
        !(color == :W ? board[[pos[0] + 1, pos[1]]] : board[[pos[0] - 1, pos[1]]]).nil?
    else
      return false unless board[new_pos].nil?
    end

    true
  end

  def deltas
    color == :W ? DELTAS : DELTAS.map { |dx, dy| [dx * -1, dy] }
  end

  def update_piece(pos)
    super
    self.first_move = false
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
