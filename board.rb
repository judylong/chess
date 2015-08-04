class Board
  attr_reader :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def setup_pieces
    populate_row(0, :W, base_row_pieces)
    populate_row(1, :W, Array.new(8) { Pawn.new })

    populate_row(7, :B, base_row_pieces.reverse)
    populate_row(6, :B, Array.new(8) { Pawn.new })

    nil
  end

  def populate_row(row_idx, color, pieces)
    grid[row_idx].each_index do |idx|
      piece = pieces[idx]
      piece.pos, piece.board, piece.color = [0, idx], self, color

      self[[0,idx]] = piece
    end

    nil
  end

  def base_row_pieces
    [
      Rook.new,
      Knight.new,
      Bishop.new,
      Queen.new,
      King.new,
      Bishop.new,
      Knight.new,
      Rook.new
    ]
  end

end
