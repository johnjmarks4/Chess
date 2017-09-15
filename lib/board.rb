class Board
  attr_accessor :board, :checkers

  def initialize
    @turn = "w"
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    set_board
    @checkers = []
  end

  def play
    loop do
      print_board
      print in_check? # for testing
      @checkers.each { |c| print [c.class, [c.r, c.c]]}
      #print still_in_check?(@board[0][5], [1, 4])
      #print @checkers.length
      #break if checkmate?
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
    @board[1][4] = " " # For testing purposes
    @board[0][4] = @w_king = King.new(0, 4, "k", "w", self) # For testing purposes
    @board[5][4] = Queen.new(5, 4, "q", "b", self) # For testing purposes
    @board[0][3] = Rook.new(0, 3, "r", "w", self)
    @board[7][2] = Bishop.new(7, 2, "b", "b", self)
    @board[7][5] = Bishop.new(7, 5, "b", "b", self)
    @board[0][2] = Bishop.new(0, 2, "b", "w", self)
    @board[0][5] = Bishop.new(0, 5, "b", "w", self)
    @board[7][1] = Knight.new(7, 1, "h", "b", self)
    @board[7][6] = Knight.new(7, 6, "h", "b", self)
    @board[0][1] = Knight.new(0, 1, "h", "w", self)
    #@board[0][6] = Knight.new(0, 6, "h", "w", self)
    @board[7][0] = Rook.new(7, 0, "r", "b", self)
    @board[7][7] = Rook.new(7, 7, "r", "b", self)
    @board[0][0] = Rook.new(0, 0, "r", "w", self)
    @board[0][7] = Rook.new(0, 7, "r", "w", self)
    @board[4][4] = Knight.new(4, 4, "k", "b", self)
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
      return false if king_escape?
      return false if shield_king?
      puts "\nCheckmate, player #{@turn} has lost"
      true
    end
  end

  def king_escape?
    @turn == "w" ? king = @w_king : king = @b_king
    x, y = king.r, king.c
    @board[king.r][king.c] = " "
    king.show_moves.each do |r, c|
      king.r, king.c = r, c
      if in_check? == false
        king.r, king.c = x, y
        @board[king.r][king.c] = king
        return true
      end
    end
    king.r, king.c = x, y
    @board[king.r][king.c] = king
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
              can_block_route << still_in_check?(s, m)
            end
          end
        end
      end
    end
    # fix
    #if can_block_route.length == @checkers.length
    false
  end

  # create stash attribute to make this method redundant
  def still_in_check?(s, m)
    con = []
    #print ["before", s.r, s.c, m, @board[m[0]][m[1]].is_a?(Piece), in_check?]
    con.push(s.r, s.c, @board[m[0]][m[1]])
    @board[m[0]][m[1]] = s
    s.r, s.c = m[0], m[1]
    #print ["after", s.r, s.c, m, @board[m[0]][m[1]].is_a?(Piece), in_check?]
    check_status = in_check?
    s.r, s.c, @board[m[0]][m[1]] = con[0], con[1], con[2]
    #print ["final", s.r, s.c, m, @board[m[0]][m[1]].is_a?(Piece), in_check?]
    check_status
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