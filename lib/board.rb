require 'yaml'

class Board
  attr_accessor :board, :checkers

  def initialize
    @turn = "w"
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    set_board
    @checkers = []
    @stash = []
  end

  def play
    loop do
      print_board
      break if checkmate?
      piece = select_piece
      move(piece)
      print_board
      switch_turn
    end
  end

  def set_board
    i = 0
    8.times do
      pawn = Pawn.new(1, i, "p", "w", self)
      @board[1][i] = pawn
      i += 1
    end

    i = 0
    8.times do
      pawn = Pawn.new(6, i, "p", "b", self)
      @board[6][i] = pawn
      i += 1
    end

    @board[7][4] = @b_king = King.new(7, 4, "k", "b", self)
    @board[0][4] = @w_king = King.new(0, 4, "k", "w", self)
    @board[7][3] = Queen.new(7, 3, "q", "b", self)
    @board[0][3] = Queen.new(0, 3, "q", "w", self)
    @board[7][2] = Bishop.new(7, 2, "b", "b", self)
    @board[7][5] = Bishop.new(7, 5, "b", "b", self)
    @board[0][2] = Bishop.new(0, 2, "b", "w", self)
    @board[0][5] = Bishop.new(0, 5, "b", "w", self)
    @board[7][1] = Knight.new(7, 1, "h", "b", self)
    @board[7][6] = Knight.new(7, 6, "h", "b", self)
    @board[0][1] = Knight.new(0, 1, "h", "w", self)
    @board[0][6] = Knight.new(0, 6, "h", "w", self)
    @board[7][0] = Rook.new(7, 0, "r", "b", self)
    @board[7][7] = Rook.new(7, 7, "r", "b", self)
    @board[0][0] = Rook.new(0, 0, "r", "w", self)
    @board[0][7] = Rook.new(0, 7, "r", "w", self)
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

  def save
    saved_game = YAML::dump(self)
    f = File.new("save.yaml", "w")
    f.puts saved_game
    f.close
  end

  def select_piece
    puts "\nPlayer #{@turn}, please select the piece you would like to move."
    piece = find_coord(gets.chomp!)
    if obj(piece).is_a?(Piece)
      obj(piece)
    else
      # This does not always run when bad input is received
      puts "Your input was not understood or you do not have a piece on that square."
      select_piece
    end
  end

  def move(piece)
    con = []
    moves = piece.show_moves.map { |m| convert_notation(m) }
    puts "#{piece.class} #{piece.color} can make the following moves:\n\n #{moves}\n"
    puts "Please select your move, or type 'cancel' to select another piece."
    input = gets.chomp!
    con << piece.r
    con << piece.c
    if moves.include?(input)
      coord = find_coord(input)
      con << @board[coord[0]][coord[1]]
      @board[piece.r][piece.c] = " "
      @board[coord[0]][coord[1]] = piece
      piece.r, piece.c = coord[0], coord[1]
      if in_check?
        puts "That move would place you in check. Please select another move."
        @board[coord[0]][coord[1]] = con.pop
        piece.c = con.pop
        piece.r = con.pop
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
    @board.each do |r|
      r.each do |s|
        if s.is_a?(Piece) && s.color != @turn && s.show_moves.include?([king.r, king.c])
          @checkers << s
          @checkers.uniq!
        else
          if @checkers.include?(s) then @checkers.delete(s) end
        end
      end
    end
    @checkers.length > 0 ? true : false
  end

  def checkmate?
    in_check?
    if @checkers.any? { |e| e.is_a?(Piece) }
      print king_escape?
      print shield_king?
      return false if king_escape?
      return false if shield_king?
      puts "\nCheckmate, player #{@turn} has lost"
      true
    end
  end

  def king_escape?
    @turn == "w" ? king = @w_king : king = @b_king
    king.show_moves.each do |m|
      temp_move(king, m)
      if in_check? == false
        undo_temp_move
        @board[king.r][king.c] = king
        return true
      else
        undo_temp_move
      end
    end
    false
  end

  #Add special code for knights
  #Only allow one route to be blocked
  def shield_king?
    @turn == "w" ? king = @w_king : king = @b_king
    can_block_route = []
    @checkers.each do |checker|
      route = draw_route(king, checker)
      route.reject! { |e| e == [king.r, king.c] }
      @board.each do |r|
        r.each do |s|
          if s.is_a?(Piece) && !s.is_a?(King) && s.color == @turn
            s.show_moves.each do |m|
              if route.include?(m)
                temp_move(s, m)
                still_in_check = in_check?
                undo_temp_move
                return true if still_in_check == false
              end
            end
          end
        end
      end
    end
    false
  end

  def temp_move(piece, move)
    @stash.push(piece, piece.r, piece.c, move, @board[move[0]][move[1]])
    @board[piece.r][piece.c] = " "
    piece.r, piece.c = move[0], move[1]
    @board[move[0]][move[1]] = piece
  end

  def undo_temp_move
    @board[@stash[3][0]][@stash[3][1]] = @stash[4]
    @stash[0].r, @stash[0].c = @stash[1], @stash[2]
    @stash = []
  end

  def draw_route(coord1, coord2)
    if coord1.is_a?(Piece) then coord1 = [coord1.r, coord1.c] end
    if coord2.is_a?(Piece) then coord2 = [coord2.r, coord2.c] end
    route = []
    # Draws a horizontal line between squares
    if coord1[0] == coord2[0]
      a, z = [coord1[1], coord2[1]].sort.each { |e| e }
      (a..z).each { |c| route << [coord1[0], c] }
    # Draws a vertical line between squares
    elsif coord1[1] == coord2[1]
      a, z = [coord1[0], coord2[0]].sort.each { |e| e }
      (a..z).each { |r| route << [r, coord1[1]] }
    # Draws a diagonal line between squares
    elsif (coord1[0] - coord1[1]).abs == (coord2[0] - coord2[1]).abs
      x = -1
      y = -1
      a, z = [coord1[0], coord2[0]].sort.each { |e| e }
      rows = (a..z).to_a
      a, z = [coord1[1], coord2[1]].sort.each { |e| e }
      cols = (a..z).to_a
      (rows.length).times { route << [rows[x+=1], cols[y+=1]] }
    end
    route
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