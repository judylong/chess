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
end
