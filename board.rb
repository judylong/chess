require_relative 'named_pieces'

class Board
  attr_reader :grid

  def initialize(grid = Array.new(8) { Array.new(8) })
    @grid = grid
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def move(start_pos, end_pos)
    piece = self[start_pos]

    raise InvalidMoveError unless !piece.nil? &&
                piece.moves.include?(end_pos) &&
                piece.valid_moves.include?(end_pos)

    move!(start_pos, end_pos)
  end

  def move!(start_pos, end_pos)
    piece = self[start_pos]

    self[end_pos] = piece
    piece.update_piece(end_pos)

    self[start_pos] = nil
  end

  def dup
    new_board = Board.new

    white_pieces = find_pieces(:W)
    black_pieces = find_pieces(:B)

    (white_pieces + black_pieces).each do |piece|
        new_board[piece.pos] = piece.dup(new_board)
    end

    new_board
  end

  def checkmate?(color)
    in_check?(color) && find_pieces(color).all? do |piece|
      piece.valid_moves.empty?
    end
  end


  def in_check?(color)
    opposing_color = (color == :W ? :B : :W)
    opposing_pieces = find_pieces(opposing_color)
    king = find_pieces(color, "King")[0]

    opposing_pieces.any? { |piece| piece.moves.include?(king.pos) }
  end

  def find_pieces(color, type = nil)
    colored_pieces = grid.flatten.compact.select { |piece| piece.color == color }
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

  def inspect
    ""
  end

  def render
    puts "  a  b  c  d  e  f  g  h"
    grid.each_with_index do |row, n|
      row_string = row.map { |square| square.nil? ? "__" : square }.join(" ")
      puts "#{(-1 * n) + 8} " + row_string
    end

    nil
  end

  def setup_pieces
    populate_row(0, :B, base_row_pieces)
    populate_row(1, :B, Array.new(8) { Pawn })

    populate_row(7, :W, base_row_pieces)
    populate_row(6, :W, Array.new(8) { Pawn })

    nil
  end

  def populate_row(row_idx, color, pieces)
    grid[row_idx].each_index do |idx|
      self[[row_idx, idx]] = pieces[idx].new([row_idx, idx], self, color)
    end

    nil
  end

  def base_row_pieces
    [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ]
  end
end
