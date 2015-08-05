require_relative 'piece'

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

    raise "No piece at start position!" if piece.nil?
    raise "Not a valid move!" unless piece.moves.include?(end_pos)

    self[end_pos] = piece
    piece.update_piece(end_pos)

    self[start_pos] = nil
  end

  def dup
    new_board = Board.new

    grid.each_with_index do |row, row_i|
      row.each_index do |col_i|
        piece = self[[row_i, col_i]]
        dup_piece = piece.nil? ? nil : duplicate_piece(piece, new_board)
        new_board[[row_i, col_i]] = dup_piece
      end
    end

    new_board
  end

  def duplicate_piece(piece, board)
    pos, color = piece.pos, piece.color

    case piece.class.to_s
    when "King"
      King.new(pos, board, color)
    when "Knight"
      Knight.new(pos, board, color)
    when "Queen"
      Queen.new(pos, board, color)
    when "Bishop"
      Bishop.new(pos, board, color)
    when "Rook"
      Rook.new(pos, board, color)
    when "Pawn"
      pawn = Pawn.new(pos, board, color)
      pawn.first_move = piece.first_move
      pawn
    end
  end


  def in_check?(color)
    opposing_color = (color == :W ? :B : :W)
    opposing_pieces = find_pieces(opposing_color)
    king = find_pieces(color, "King")[0]

    opposing_pieces.any? { |piece| piece.moves.include?(king.pos) }
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

  # def inspect
  #   " "
  # end

  def render
    puts "  0  1  2  3  4  5  6  7"
    grid.each_with_index do |row, n|
      puts "#{n} " + row.map { |square| square.nil? ? "__" : square }.join(" ")
    end

    nil
  end

  def setup_pieces
    populate_row(0, :B, base_row_pieces)
    populate_row(1, :B, Array.new(8) { Pawn.new })

    populate_row(7, :W, base_row_pieces)
    populate_row(6, :W, Array.new(8) { Pawn.new })

    nil
  end

  def populate_row(row_idx, color, pieces)
    grid[row_idx].each_index do |idx|
      piece = pieces[idx]
      piece.pos, piece.board, piece.color = [row_idx, idx], self, color

      self[[row_idx, idx]] = piece
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
