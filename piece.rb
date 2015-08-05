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
      positions.concat(possible_moves) #unless possible_moves.nil?
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

  def move_into_check?(possible_pos)
    new_board = board.dup
    new_board.move!(pos, possible_pos)
    new_board.in_check?(color)
  end

  def valid_moves
    moves.reject { |move| move_into_check?(move) }
  end

  def to_s
    piece = self.class.to_s[0..1]
    self.color == :W ? piece.red : piece.black
  end

  def deltas
    self.class::DELTAS
  end

  def dup(new_board)
    self.class.new(pos, new_board, color)
  end
end

class SlidingPiece < Piece
  def potential_moves(delta)
    moves = []
    captured_piece = false
    current_pos = pos

    until captured_piece || !valid_pos?(move = next_pos(current_pos, delta))
      moves << move
      captured_piece = true if !board[move].nil? && board[move].color != color
      current_pos = move
    end

    moves
  end
end

class SteppingPiece < Piece
  def potential_moves(delta)
    move = next_pos(pos, delta)
    return [move] if valid_pos?(move)

    []
  end
end
