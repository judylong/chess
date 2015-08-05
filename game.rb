require_relative 'board'

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
      board.move(*get_move)
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

  def get_move
    begin
      positions = prompt.split(",").map(&:strip)
      parsed_positions = positions.map { |position| parse(position) }
    rescue ArgumentError => e
      puts e.message
      retry
    end

    parsed_positions
  end

  def prompt
    puts "Enter a move:"
    print "> "
    input = gets.chomp.downcase
  end

  def parse(move)
    raise ArgumentError.new("Invalid move!") if move.length != 2
    col, row = move.split("")
    row = Integer(row)
    unless col.between?("a", "h") && row.between?(1, 8)
      raise ArgumentError.new("Invalid move!")
    end

    [row - 1, col.ord - 97]
  end
end
