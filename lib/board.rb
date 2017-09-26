require 'yaml'

class Board
  attr_accessor :board, :checkers, :can_castle

  def initialize
    @turn = "w"
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    set_board
    @w_king = @board[0][4]
    @b_king = @board[7][4]
    @can_castle = ""
    @stash = []
  end

  def play
    print "\nType 'save' at any time to save your game."
    loop do
      print_board
      break if checkmate?
      piece = select_piece
      move(piece)
      switch_turn
    end
  end

  def set_board
    pieces = ["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]
    set_pieces(pieces, 0, 0, 4)
    set_pieces(pieces, 0, 7, 4)
  end

  def set_pieces(pieces, i, x, y)
    x < 2 ? c = "w" : c = "b"
    if y > 7 || y < 0
      return
    else
      @board[x][y] = Piece.const_get(pieces[i]).new(x, y, c, self)
      if y < 5 && x == 0 || y < 5 && x == 7
        set_pieces(pieces, i+=1, x, y-=1)
        pieces, i, y = pieces[2..-1], -1, 4
      end
      if y > 3 && x == 0 || y > 3 && x == 7
        set_pieces(pieces, i+=1, x, y+=1)
        i, y = -1, -1
        c == "w" ? x = 1 : x = 6
      end
      set_pieces(pieces, i, x, y+=1)
    end
  end

  def print_board
    #NOTE: requires unicode-supported font to display pieces. For Windows, try DejaVu Sans Mono.
    print "\n\n  "
    (1..8).to_a.reverse.each do |i|
      r = @board[i-1][0..7].map! { |square| square != " " ? square = square.unicode : square }
      33.times { print "-" }
      puts "\n" + "#{i} " + "| " + r.join(" | ") + " |" + "\n"
      print "  "
    end
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
    puts "\nYour game has been successfully saved\n"
  end

  def select_piece
    puts "\nPlayer #{@turn}, please select the piece you would like to move."
    input = gets.chomp!
    piece = find_coord(input)

    if  piece.length == 2 && 
        !piece.include?(nil) && 
        obj(piece).is_a?(Piece)

      if obj(piece).color == @turn
        obj(piece)
      else
        puts "\nPlayer #{@turn}, that piece does not belong to you."
        select_piece
      end
      
    elsif input.downcase == "save"
      save
      select_piece
    else
      puts "\nYour input was not understood, or you do not have a piece with open moves at that square."
      puts "Please select a piece in the following format: 2a."
      select_piece
    end
  end

  def move(piece)
    user_input = choose_move(piece)
    if user_input.downcase == "castle"
      castle
    else
      move = check_legal(piece, user_input)
      @board[move[0]][move[1]] = piece
      piece.r, piece.c = move[0], move[1]
      piece.total_moves += 1
      if piece.is_a?(Pawn) && piece.ep_pawn.include?(move)
        @board[move[0]-1][move[1]] = " "
      end
    end
    @can_castle = ""
    promote_pawn(piece)
  end

  def castle
    king, rook = @can_castle[0], @can_castle[1]
    @board[rook.r][rook.c], @board[king.r][king.c] = king, rook
    king.r, king.c = rook.r, rook.c
  end

  def promote_pawn(piece)
    if piece.is_a?(Pawn) && piece.r == 7 || piece.r == 0
      @board[piece.r][piece.c] = piece.promote
    end
  end

  def check_legal(piece, user_input)
    move = find_coord(user_input)
    temp_move(piece, move)
    if in_check?
      puts "That move would place you in check. Please select another move."
      undo_temp_move
      check_legal(piece, user_input)
    else
      undo_temp_move
      move
    end
  end

  def choose_move(piece)
    moves = piece.show_moves.map { |m| convert_notation(m) }
    moves << "castle: #{@can_castle}" if !@can_castle.empty?
    puts "#{piece.class} #{piece.color} can make the following moves:\n\n #{moves}\n"
    puts "Please select your move, or type 'cancel' to select another piece."
    input = gets.chomp!
    if input.downcase == "save"
      save
      return choose_move(piece)
    elsif input.downcase == "cancel"
      piece = select_piece
      return choose_move(piece)
    elsif moves.include?(input) == false
      puts "Your selection was not recognized. Please try again."
      return choose_move(piece)
    else
      input
    end
  end

  def in_check?
    @turn == "w" ? king = @w_king : king = @b_king
    checkers = []
    @board.each do |r|
      r.each do |s|
        if s.is_a?(Piece) && s.color != @turn && s.show_moves.include?([king.r, king.c])
          checkers << s
          checkers.uniq!
        end
      end
    end

    checkers.length > 0 ? checkers : false
  end

  def checkmate?
    if in_check? != false
      return false if king_escape?
      return false if shield_king?
      puts "\nCheckmate, player #{@turn} has lost"
      return true
    end
    false
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

  # This should be refactored.
  def shield_king?
    @turn == "w" ? king = @w_king : king = @b_king
    can_block_route = []
    checkers = in_check?
    if checkers != false
      checkers.each do |checker|

        if checker.is_a?(Knight)
          route = [[checker.r, checker.c]]
        else
          route = draw_route(king, checker)
        end

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
    end
    false
  end

  def temp_move(piece, move)
    @stash = []
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