require 'yaml'

class Game
	attr_accessor :board, :winner, :black_king, :white_king

	def initialize
    @board = Array.new(8).map { Array.new(8) }
    @board.each { |rows| rows.map! { |squares| squares = " " } }
    @c_piece = ""
    @winner = false

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

    @board[7][3] = Queen.new(7, 3, "q", "b")
    @board[0][3] = Queen.new(0, 3, "q", "w")
    @board[7][4] = King.new(7, 4, "k", "b")
    @board[0][4] = King.new(0, 4, "k", "w")
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

    @black_king = @board[7][4]
    @white_king = @board[0][4]

    @black_knight1 = @board[7][1]
    @black_knight2 = @board[7][6]
    @white_knight1 = @board[0][1]
    @white_knight2 = @board[0][6]
  end

  def make_player(color)
    Player.new(color)
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

  def save
    saved_game = YAML::dump(self)
    f = File.new("save.yaml", "w")
    f.puts saved_game
    f.close
  end

  def piece_menu(player)
    container = []

    @board.each_with_index do |row, i|
      row.each_with_index do |_, j|

        if @board[i][j] != " " && @board[i][j].color == player.color && @board[i][j].show_moves(self) != []

          container << "#{translate_from([i, j])}"
        end
      end
    end

    return container
  end

  def pick_piece(player, piece_menu)
    if player.color == "w"
      king = @white_king
      other_player = "b"
    else
      king = @black_king
      other_player = "w"
    end

    if player.checked == true
      pieces = []
      puts "\n Player #{player.color}, you must move out of check. \n"
      route = shield_king?(king, @c_piece)

      piece_menu(player).each do |piece| 
        piece = translate_to(piece)
        if @board[piece[0]][piece[1]].class != King
          @board[piece[0]][piece[1]].show_moves(self).each do |move|
            if route.include?(move)
              pieces << "#{translate_from([piece[0], piece[1]])}"
            end
          end
        elsif @board[piece[0]][piece[1]].is_a?(King)
          if king.show_moves(self).any? { |move| checked?(move, other_player, player) == false }
            pieces << "#{translate_from([king.row, king.column])}"
          end
        end
      end
      piece_menu = pieces
    end

    puts "\n\n"
    puts 'Player ' + "#{player.color}" + ', please select the piece you would like to move (or type "save" to save game.)'
    puts "\n"

    print piece_menu
    puts "\n\n"

    input = gets.chomp

    if input == "save" || input == "save game"
      save

      puts "Game saved. \n"
      puts "Player #{player.color}, please select the piece you would like to move."
      print piece_menu
      input = gets.chomp
    end

    until piece_menu.include?(input) || piece_menu == input
      puts "You do not have a piece at that location. Please select from the locations listed."
      print piece_menu
      puts "\n"
      input = gets.chomp
    end

    input = translate_to(input)
    piece = @board[input[0]][input[1]]
    return piece
  end

  def move(player, piece)
    moves = []
    if player.color == "w"
      king = @white_king
      other_player = "b"
    else
      king = @black_king
      other_player = "w"
    end

    if player.checked == true
      route = shield_king?(king, @c_piece)
      if piece.is_a?(King)
        king.show_moves(self).each do |move| 
          if checked?(move, other_player, player) == false
            moves << move
          end
        end
      else
        piece.show_moves(self).each do |move|
          if route.include?(move)
            moves << move
          end
        end
      end
    else
      moves = piece.show_moves(self)
    end

    moves.map! do |ary|
      ary = translate_from(ary)
    end

    puts "#{piece.type}#{piece.color} can make the following moves: \n \n"
    print moves
    puts "\n"

    puts 'Please select your move, or type "cancel" to select another piece.'
    input = gets.chomp

    if input == "cancel" || input == "Cancel"
      return "cancel"
    end

    while moves.include?(input) == false
      puts 'The selected piece cannot move to that square. Please select another move or type "cancel" to select another piece.'
      puts "\n"
      print moves
      puts "\n"
      input = gets.chomp
    end

    input = translate_to(input)
    case piece.type
    when "p" then dummy = Pawn.new(piece.row, piece.column, "p", piece.color)
    when "r" then dummy = Rook.new(piece.row, piece.column, "r", piece.color)
    when "h" then dummy = Knight.new(piece.row, piece.column, "h", piece.color)
    when "b" then dummy = Bishop.new(piece.row, piece.column, "b", piece.color)
    when "k" then dummy = King.new(piece.row, piece.column, "k", piece.color)
    when "q" then dummy = Queen.new(piece.row, piece.column, "q", piece.color)
    end
    @board[piece.row][piece.column] = " "
    @board[input[0]][input[1]] = piece
    piece.row = input[0]
    piece.column = input[1]

    if checked?([king.row, king.column], other_player, player) != false
      puts "\n"
      puts 'That move would put you in check. Please select another move or type "cancel" to select another piece.'
      @board[piece.row][piece.column] = " "
      @board[dummy.row][dummy.column] = dummy
      piece.row = dummy.row
      piece.column = dummy.column
      player.checked = false
      return move(player, piece)
    end
  end

  def translate_from(coordinate)
    alph = ('a'..'h').to_a

    coordinate[0] += 1
    coordinate[1] = alph[coordinate[1]]
    coordinate = coordinate.join
    return coordinate
  end

  def translate_to(coordinate)
    if coordinate.class == Array
      coordinate = coordinate.join(", ")
    end

    if coordinate.match(",")
      coordinate = coordinate.split(",")
    elsif coordinate.match(" ")
      coordinate = coordinate.split(" ")
    else
      coordinate.insert 1, " "
      coordinate = coordinate.split(" ")
    end

    alph = ('a'..'h').to_a

    coordinate[0] = coordinate[0].to_i 
    coordinate[0] -= 1
    coordinate[1] = alph.index(coordinate[1])
    return coordinate
  end

  def promote_pawn(player)
    pawn = ""
    row = ""

    @board[0].each_with_index do |_, i|

      if @board[0][i].class == Pawn
        pawn = @board[0][i]
        row = 0
      elsif @board[7][i].class == Pawn
        pawn = @board[7][i]
        row = 7
      end
    end

    if pawn != ""
      puts "One of your pawns has reached the back row. Type the letter for the piece you would like to trade it for:"

      puts "q = Queen\nb = Bishop\nk = Knight\nr = Rook"

      input = gets.chomp

      case input
      when "q"
        @board[row][pawn.column] = Queen.new(row, pawn.column, "q", player.color)
      when "b"
        @board[row][pawn.column] = Bishop.new(row, pawn.column, "b", player.color)
      when "k"
        @board[row][pawn.column] = Knight.new(row, pawn.column, "h", player.color)
      when "r"
        @board[row][pawn.column] = Rook.new(row, pawn.column, "r", player.color)
      else
        puts "Your input was not understood."
        promote_pawn(player)
      end
    end
  end

  def checked?(square, attacker, defender)
    defender.color == "w" ? king = @white_king : king = @black_king
    a_moves = []
    puts square.inspect
    dummy = @board[square[0]][square[1]]

    @board[king.row][king.column] = " "
    @board[square[0]][square[1]] = " "

    @board.each do |row|
      row.each do |square|
        if square.class != String && square.color != defender.color #if square is enemy piece
          a_moves << [square.row, square.column] #include pieces in attacker moves to later check if defender can take them to block

          square.show_moves(self).each do |move|
            @c_piece = square if move == [king.row, king.column]
            a_moves << move
          end

          if square.class == Pawn
            if square.color == "w"
              @c_piece = square if [square.row + 1, square.column + 1] == [king.row, king.column]
              a_moves << [square.row + 1, square.column + 1]
              @c_piece = square if [square.row + 1, square.column - 1] == [king.row, king.column]
              a_moves << [square.row + 1, square.column - 1]
            elsif square.color == "b"
              @c_piece = square if [square.row - 1, square.column + 1] == [king.row, king.column]
              a_moves << [square.row - 1, square.column + 1]
              @c_piece = square if [square.row - 1, square.column - 1] == [king.row, king.column]
              a_moves << [square.row - 1, square.column - 1]
            end
          end
        end
      end
    end

    if a_moves.include?([king.row, king.column])
      defender.checked = true
      @board[king.row][king.column] = king
      @board[square[0]][square[1]] = dummy
      return a_moves
    else
      @board[king.row][king.column] = king
      @board[square[0]][square[1]] = dummy
      false
    end
  end

  def checkmate?(a_moves, attacker, defender)
    d_moves = []
    k_moves = []
    defender.color == "w" ? king = @white_king : king = @black_king
    @board.each do |row| 
      row.each do |square|
        if square.class != String
          if square.color == defender.color
            if square.is_a?(King)
              square.show_moves(self).each do |move|
                if checked?(move, attacker, defender) == false
                  k_moves << move
                end
              end
            else
              square.show_moves(self).each do |move|
                d_moves << move
              end
            end
          end
        end
      end
    end

    route = shield_king?(king, @c_piece)
        
    if d_moves.none? { |defensive_move| route.include?(defensive_move) }
      if k_moves == []
        @winner = true
        puts "\n Checkmate! Player #{defender.color} loses!"
        return "Checkmate! Player #{defender.color} loses!"
      end
    end
  end

  def shield_king?(king, c_piece)
    route = []

    if c_piece.is_a?(Knight)
      route << [c_piece.row, c_piece.column]
      return route
    end

    row = king.row
    column = king.column

    route << [c_piece.row, c_piece.column]

    if c_piece.row > king.row
      #checker top
      if c_piece.column == king.column
        until row == c_piece.row
          route << [row += 1, column]
        end
      #checker top-right
      elsif c_piece.column > king.column
        until row == c_piece.row && column == c_piece.column
          route << [row += 1, column += 1]
        end
      #checker top-left
      elsif c_piece.column < king.column
        until row == c_piece.row && column == c_piece.column
          route << [row += 1, column -= 1]
        end
      end
    elsif c_piece.row == king.row
      #checker on right
      if c_piece.column > king.column
        until column == c_piece.column
          route << [row, column += 1]
        end
      #checker on left
      elsif c_piece.column < king.column
        until column == c_piece.column
          route << [row, column -= 1]
        end
      end
    elsif c_piece.row < king.row
      #checker bottom
      if c_piece.column == king.column
        until row == c_piece.row && column == c_piece.column
          route << [row -= 1, column]
        end
      #checker bottom-right
      elsif c_piece.column > king.column
        until row == c_piece.row && column == c_piece.column
          route << [row -= 1, column += 1]
        end
      #checker bottom-left
      elsif c_piece.column < king.column
        until row == c_piece.row && column == c_piece.column
          route << [row -= 1, column -= 1]
        end
      end
    end
    return route
  end
end