require_relative 'piece'

class Pawn < Piece
  CAPTURE_DELTAS = [
    [1, -1], #capture
    [1,  1], #capture
  ]

  STEP_DELTA = [
    [1,  0] #anytime
  ]

  DOUBLE_STEP_DELTA = [
    [2,  0], #first move
  ]

  attr_accessor :first_move

  def initialize(pos, board, color)
    super
    @first_move = true
  end

  def first_move?
    @first_move
  end

  def dup(new_board)
    copy = super
    copy.first_move = first_move

    copy
  end

  def moves
    possible_moves = []

    possible_moves.concat(capturable_positions)

    step_pos = new_pos(deltas(STEP_DELTA).first)

    if board[step_pos].nil?
      possible_moves << step_pos
    else
      return possible_moves
    end

    if first_move?
      possible_moves << double_step_pos unless double_step_pos.empty?
    end

    possible_moves
  end

  def double_step_pos
    position = new_pos(deltas(DOUBLE_STEP_DELTA).first)
    return position if board[position].nil?

    []
  end

  def capturable_positions
    deltas(CAPTURE_DELTAS).map { |delta| new_pos(delta) }.select do |position|
      !board[position].nil? && board[position].color != color
    end
  end

  def new_pos(delta)
    x, y = pos
    dx, dy = delta

    [x + dx, y + dy]
  end

  def deltas(specific_deltas)
    color == :B ? specific_deltas : specific_deltas.map { |dx, dy| [dx * -1, dy] }
  end

  def update_piece(pos)
    super
    self.first_move = false
  end

  def to_s
    color == :W ? "\u2659" : "\u265F"
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

  def to_s
    color == :W ? "\u2658" : "\u265E"
  end
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

  def to_s
    color == :W ? "\u2654" : "\u265A"
  end
end

class Bishop < SlidingPiece
  DELTAS = [
    [ 1,  1],
    [ 1, -1],
    [-1, -1],
    [-1,  1],
  ]

  def to_s
    color == :W ? "\u2657" : "\u265D"
  end
end

class Rook < SlidingPiece
  DELTAS = [
    [ 1,  0],
    [ 0, -1],
    [-1,  0],
    [ 0,  1],
  ]

  def to_s
    color == :W ? "\u2656" : "\u265C"
  end
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

  def to_s
    color == :W ? "\u2655" : "\u265B"
  end
end
