require 'yaml'

class Board
  attr_accessor :board, :checkers, :testing

  def initialize
    @turn = "w"
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    set_board
    @w_king = @board[0][4]
    @b_king = @board[7][4]
    @testing = false
  end

  def play
    print "\nType 'save' at any time to save your game."
    loop do
      @stash = []
      print_board
      break if checkmate?
      move
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

  def move
    begin

      puts "\nPlayer #{@turn}, please select the piece you would like to move."

      piece = check_for_keywords($stdin.gets.chomp)
      return piece.call if piece.is_a?(Proc)
      piece = obj(piece)
      return error_messages(:color_error) if piece.color != @turn

      moves = piece.show_moves.map { |m| translate(m) }
      moves << "castle" if can_castle.include?([piece.r, piece.c])
      return error_messages(:no_moves_error) if moves.empty?

      puts "#{piece.class} #{piece.color} can make the following moves:\n\n #{moves}\n"
      puts "Please select your move, or type 'cancel' to select another piece."

      return "quit" if @testing == true
      move = check_for_keywords($stdin.gets.chomp)
      return [piece].each(&move) if move.is_a?(Proc)
      return implement_move(piece, move)

    rescue => e 
      error_messages(e)
    end
  end

  def implement_move(piece, to, *castle)
    stash_move(piece, to)
    @board[piece.r][piece.c] = " " if castle.empty?
    @board[to.first][to.last] = piece
    piece.r, piece.c = to.first, to.last
    piece.total_moves += 1 if [Pawn, Rook, King].include?(piece.class)
  end

  def check_for_keywords(input)
    input.downcase!
    keywords = ["save", "cancel", "castle"]

    if keywords.include?(input)
      handle_keyword(input)
    else
      translate(input)
    end
  end

  def translate(input)
    if input.is_a?(String)
      find_coord(input)
    else
      convert_notation(input)
    end
  end

  def error_messages(e)
    case e
    when NoMethodError
      puts "\nYour input was not understood, or you do not have a piece with open moves at that square."
      puts "Please select a piece in the following format: 2a."

    when :color_error
      puts "\nPlayer #{@turn}, that piece does not belong to you."

    when :check_error
      puts "\nThat move would place you in check. Please select another move."
      undo_move

    when :no_moves_error
      puts "\nThat piece does not have any open moves. Please select another move."

    end
    move
  end

  def handle_keyword(k)
    case k
    when "save"
      save
      key_method = Proc.new { move }
    when "cancel"
      key_method = Proc.new { move }
    when "castle"
      key_method = Proc.new { |piece| castle(piece) }
    end
    key_method
  end

  def castle(piece)
    castle = can_castle

    if castle.length > 1
      puts "Input the piece you would like to castle."
      cp = translate($stdin.gets.chomp)
      swap_piece = @board[cp.first][cp.last]

      if castle.include?(cp) && piece.class != swap_piece.class
        swap_piece_to = [piece.r, piece.c]
        [piece, cp, swap_piece, swap_piece_to].each_slice(2) do |x, y|
          implement_move(x, y, "castle")
        end
      else
        puts "That piece is not available to castle"
        castle(piece)
      end      
    else
      puts "You do not have the pieces necessary to castle. Please select another move."
      move
    end
  end

  def can_castle
    can = []

    [0, 7].each do |i|
      left = @board[i].slice(0..4)
      right = @board[i].slice(4..7)

      if pieces_are_swapable(left)
        can << left[0] << left[-1]
      end

      if pieces_are_swapable(right)
        can << right[0] << right[-1]
      end
    end
    can.reject! { |e| e.color != @turn }
    can.map! { |e| e = [e.r, e.c] }
    can
  end

  def pieces_are_swapable(slice)
    slice[0].is_a?(Piece) &&
    slice[-1].is_a?(Piece) &&
    [slice[0].is_a?(King) || slice[0].is_a?(Rook)] &&
    [slice[-1].is_a?(King) || slice[-1].is_a?(Rook)] &&
    slice[0].total_moves == 0 && 
    slice[-1].total_moves == 0 &&
    slice[1..-2].all? { |e| e == " " }
  end

  def promote_pawn(piece)
    if piece.r == 7 || piece.r == 0
      @board[piece.r][piece.c] = piece.promote
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
      implement_move(king, m)
      if in_check? == false
        undo_move
        @board[king.r][king.c] = king
        return true
      else
        undo_move
      end
    end
    false
  end

  def shield_king?
    @turn == "w" ? king = @w_king : king = @b_king
    checkers = in_check?
    checking_routes = []

    if !checkers == false

      friendly_pieces = all_player_pieces
      routes = checking_routes(checkers)
      routes.reject! { |s| s == [king.r, king.c] }

      routes.each do |r|
        friendly_pieces.each do |pc|
          m = pc.show_moves.select { |move| r.include?(move) }
          if !m.empty?
            implement_move(pc, m[0])
            if in_check? == false
              undo_move
              return true
            else
              undo_move
            end
          end
        end
      end
    end
    false
  end

  def all_player_pieces
    pieces = []
    @board.each do |row|
      row.each do |s|
        pieces << s if s.is_a?(Piece) && !s.is_a?(King) && s.color == @turn
      end
    end
    pieces
  end

  def checking_routes(checkers)
    @turn == "w" ? king = @w_king : king = @b_king
    con = []
    checkers.each do |c|
      if c.is_a?(Knight)
        route = [[c.r, c.c]]
      else
        route = draw_route(king, c)
      end
      con << route
    end
    con
  end

  def stash_move(piece, move)
    @stash = []
    @stash.push(piece, piece.r, piece.c, move, @board[move[0]][move[1]])
  end

  def undo_move
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