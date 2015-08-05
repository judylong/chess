require_relative 'piece'

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
    @first_move
  end

  def dup(new_board)
    copy = super
    copy.first_move = first_move

    copy
  end

  def valid_pos?(new_pos)
    return false unless board.on_board?(new_pos)
    if capture_move?(new_pos)
      return false unless can_capture?(new_pos)
    elsif double_move?(new_pos)
      return false unless first_move?
      return false unless valid_double_move?(new_pos)
    else
      return false unless board[new_pos].nil?
    end

    true
  end

  def can_capture?(new_pos)
    !board[new_pos].nil? && board[new_pos].color != color
  end

  def capture_move?(new_pos)
    new_pos[1] != pos[1]
  end

  def double_move?(new_pos)
    new_pos[0] == pos[0] + 2
  end

  def valid_double_move?(new_pos)
    new_pos_open = board[new_pos].nil?
    if color == :B
      adjacent_pos = board[[pos[0] + 1, pos[1]]]
    else
      adjacent_pos = board[[pos[0] - 1, pos[1]]]
    end

    new_pos_open && adjacent_pos.nil?
  end

  def deltas
    color == :B ? DELTAS : DELTAS.map { |dx, dy| [dx * -1, dy] }
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
