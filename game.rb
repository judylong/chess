require_relative 'board'
require_relative 'error'

class Game
  attr_reader :board
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @board.setup_pieces
    @current_player = :W
  end

  def play
    until board.checkmate?(current_player)
      system("clear")
      board.render
      play_turn
      switch_player
    end

    system("clear")
    board.render
    switch_player
    puts "Game over! #{current_player} wins!"
  end

  def switch_player
    self.current_player = (current_player == :W ? :B : :W)
  end

  def play_turn
    board.move(*get_move)
  rescue InvalidMoveError => e
      puts e.message
      retry
  end

  def get_move
    input = prompt
    parse_positions(input)
  end


  def parse_positions(input)
    positions = input.split(",").map(&:strip)
    parsed_positions = positions.map { |position| parse(position) }
    validate_move(parsed_positions.first)

    parsed_positions
  end

  def validate_move(start_pos)
    error_message = nil

    piece = board[start_pos]
    if piece.nil?
      error_message = "Invalid move! Start position is empty."
    elsif current_player != board[start_pos].color
      error_message = "Invalid move! Chosen piece is not yours."
    end

    raise InvalidMoveError.new(error_message) unless error_message.nil?

    nil
  end

  def prompt
    print "\n"
    puts "#{current_player}'s turn. Enter a move:"
    print "> "
    input = gets.chomp.downcase
  end

  def parse(move)
    raise InvalidMoveError if move.length != 2
    col, row = move.split("")
    row = to_i(row)
    unless move_in_range?(row, col)
      raise InvalidMoveError
    end

    [(-1 * row) + 8, col.ord - 97]
  end

  def to_i(row)
    row = Integer(row)
  rescue ArgumentError
    raise InvalidMoveError
  end

  def move_in_range?(row, col)
    col.between?("a", "h") && row.between?(1, 8)
  end

end
