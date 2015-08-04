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
end

def SlidingPiece < Piece
  def initialize(pos, board, color)
    super
  end

  def potential_moves(delta)
    moves = []

    until !valid_pos?(move = next_pos(pos, delta))
      moves << move
    end

    moves
  end
end
