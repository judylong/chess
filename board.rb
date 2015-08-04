require_relative 'piece'

class Board
  attr_reader :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end


  def find_pieces(color, type = nil)
    colored_pieces = grid.flatten.select do |piece|
      !piece.nil? && piece.color == color
    end

    colored_pieces.select! { |piece| piece.class.to_s == type } unless type.nil?

    colored_pieces
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

  def inspect
    " "
  end

  def render
    puts "  0  1  2  3  4  5  6  7"
    grid.each_with_index do |row, n|
      puts "#{n} " + row.map { |square| square.nil? ? "__" : square }.join(" ")
    end

    nil
  end

  def populate_row(row_idx, color, pieces)
    grid[row_idx].each_index do |idx|
      piece = pieces[idx]
      piece.pos, piece.board, piece.color = [row_idx, idx], self, color

      self[[row_idx,idx]] = piece
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
