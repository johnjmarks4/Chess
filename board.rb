class Board
  attr_accessor :board

  def initialize
    @turn = "w"
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    set_board
  end

  def set_board
    i = 0
    8.times do
      pawn = Pawn.new(1, i, "p", "w")
      @board[1][i] = pawn
      i += 1
    end

    i = 0
    8.times do
      pawn = Pawn.new(6, i, "p", "b")
      @board[6][i] = pawn
      i += 1
    end

    @board[7][4] = @b_king = King.new(7, 4, "k", "b")
    @board[0][4] = @w_king = King.new(0, 4, "k", "w")
    @board[7][3] = Queen.new(7, 3, "q", "b")
    @board[0][3] = Queen.new(0, 3, "q", "w")
    @board[7][2] = Bishop.new(7, 2, "b", "b")
    @board[7][5] = Bishop.new(7, 5, "b", "b")
    @board[0][2] = Bishop.new(0, 2, "b", "w")
    @board[0][5] = Bishop.new(0, 5, "b", "w")
    @board[7][1] = Knight.new(7, 1, "h", "b")
    @board[7][6] = Knight.new(7, 6, "h", "b")
    @board[0][1] = Knight.new(0, 1, "h", "w")
    @board[0][6] = Knight.new(0, 6, "h", "w")
    @board[7][0] = Rook.new(7, 0, "r", "b")
    @board[7][7] = Rook.new(7, 7, "r", "b")
    @board[0][0] = Rook.new(0, 0, "r", "w")
    @board[0][7] = Rook.new(0, 7, "r", "w")
  end

  def print_board
    #NOTE: requires unicode-supported font to display pieces. For Windows, try DejaVu Sans Mono.
    row1 = @board[0][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row2 = @board[1][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row3 = @board[2][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row4 = @board[3][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row5 = @board[4][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row6 = @board[5][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row7 = @board[6][0..7].map! { |square| square != " " ? square = square.unicode : square }
    row8 = @board[7][0..7].map! { |square| square != " " ? square = square.unicode : square }
    print "\n\n  "
    33.times { print "-" }
    puts "\n" + "8 " + "| " + row8.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "7 " + "| " + row7.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "6 " + "| " + row6.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "5 " + "| " + row5.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "4 " + "| " + row4.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "3 " + "| " + row3.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "2 " + "| " + row2.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n" + "1 " + "| " + row1.join(" | ") + " |" + "\n"
    print "  "
    33.times { print "-" }
    puts "\n"
    print "    a   b   c   d   e   f   g   h"
  end

  def switch_turn
    @turn == "w" ? @turn = "b" : @turn = "w"
  end

  def play
    loop do
      print_board
      piece = select_piece
      move(piece)
      print_board
      switch_turn
    end
  end

  def select_piece
    puts "\nPlayer #{@turn}, please select the piece you would like to move."
    piece = find_coord(gets.chomp!)
    if obj(piece).is_a?(Piece)
      obj(piece)
    else
      puts "Your input was not understood or you do not have a piece on that square."
      select_piece
    end
  end

  def move(piece)
    moves = piece.show_moves(self).map { |m| convert_notation(m) }
    puts "#{piece.class} #{piece.color} can make the following moves:\n\n #{moves}\n"
    puts "Please select your move, or type 'cancel' to select another piece."
    input = gets.chomp!
    if moves.include?(input)
      coord = find_coord(input)
      @board[piece.r][piece.c] = " "
      @board[coord[0]][coord[1]] = piece
      if in_check?
        puts "That move would place you in check. Please select another move."
        @board[coord[0]][coord[1]] = " "
        @board[piece.r][piece.c] = piece
        move(piece)
      else
        piece.r, piece.c = coord[0], coord[1]
      end
    elsif input.downcase == "cancel"
      return select_piece
    else
      puts "Your selection was not recognized. Please try again."
      move(piece)
    end
  end

  def in_check?
    @turn == "w" ? king = @w_king : king = @b_king
    @board.any? do |r|
      r.any? do |s|
        s.is_a?(Piece) && s.color != @turn && s.show_moves(self).include?([king.r, king.c])
      end
    end
  end

  def obj(coord)
    @board[coord[0]][coord[1]]
  end

  def convert_notation(coord)
    alph = ('a'..'h').to_a
    coord[0] += 1
    coord[1] = alph[coord[1]]
    coord.join
  end

  def find_coord(input)
    alph = ('a'..'h').to_a
    input = input.split('')
    input[0] = input[0].to_i - 1
    input[1] = alph.index(input[1])
    input
  end
end