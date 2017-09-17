require 'yaml'

class Game
	attr_accessor :board, :winner, :b_king, :w_king, :turn

	def initialize
    @board_obj = Board.new
    @board = @board_obj.board
    @player1 = "w"
    @player2 = "b"
    @turn = @player1
    @winner = false
    
    @b_king = [@board[7][4].r, @board[7][4].c]
    @w_king = [@board[0][4].r, @board[0][4].c]
  end

  def print_board
    @board_obj.print_board
  end

  def switch_turn
    @turn == @player1 ? @turn = @player2 : @turn = @player1
  end

  def open_pieces
    container = []

    @board.each_with_index do |row, i|
      row.each_with_index do |_, j|

        # Refactor

        if @board[i][j] != " " && @board[i][j].color == @turn && @board[i][j].show_moves(self) != []
          container << "#{translate_from([i, j])}"
        end
      end
    end

    if checked? == true then container = move_out_of_check  end

    container
  end

  def move(open_pieces)
    @turn == "w" ? king = @w_king : king = @b_king

    input = "cancel"
    while input.downcase == "cancel"
      prompt_piece_choice(open_pieces)
      input = gets.chomp
      input = validate_piece(input, open_pieces)
      chosen_piece = translate_to(input)

      moves = prompt_move_choice(chosen_piece)
      input = gets.chomp
    end

    input = validate_available(input, moves)
    chosen_move = translate_to(input)
    validate_no_check(chosen_move, chosen_piece)
  end

  def checked?
    @turn == "w" ? king = @w_king : king = @b_king

    @board.any? do |r|
      r.any? do |s|
        s.is_a?(Piece) && s.color != @turn && s.show_moves(self).include?(king)
      end
    end
  end

  def checkmate?
    return true if move_out_of_check.empty?
    false
  end

  def shield_king(king)
    shielders = []
    place_holder = []
    all_pieces.each do |piece|
      # Collects all pieces with a move sharing one coordinate with king
      piece.show_moves(self).each do |m|
        if routes_cross?(m, king)
          place_holder << @board[m[0]][m[1]]
          @board[m[0]][m[1]] = piece
          print_board
          shielders << piece if checked? == false #this is the part that's broken, predictably!
          @board[m[0]][m[1]] = place_holder.pop
        end
      end
    end
    shielders
  end

  def routes_cross?(m, k)
    m[0] == k[0] || m[1] == k[1] || 
    diagonals(k).include?(m)
  end

  def diagonals(coord)
    dummy1 = Bishop.new(coord[0], coord[1], "b", "b")
    dummy2 = Bishop.new(coord[0], coord[1], "b", "b")
    #print ["new", coord, (dummy1.show_moves(self) + dummy2.show_moves(self)).uniq]
    (dummy1.show_moves(self) + dummy2.show_moves(self)).uniq
  end

  def all_pieces
    pieces_on_board = []
    @board.each do |r|
      pieces_on_board << r.find_all { |s| s.is_a?(Piece) && s.color == @turn }
      pieces_on_board.flatten!
    end
    pieces_on_board
  end

  private

    def move_out_of_check
      @turn == "w" ? king = @w_king : king = @b_king
      pieces = []
      # Put messages into game loop
      puts "\n Player #{@turn}, you must move out of check. \n"
      route = shield_king(king)

      open_pieces.each do |piece| 
        square = translate_to(piece)

        # Checks if any of player's pieces can shield king from attacker
        if obj(square).class != King
          obj(square).show_moves(self).each do |move|
            if route.include?(move)
              pieces << "#{translate_from([coord[0], coord[1]])}" #error is somewhere here
            end
          end
        # Checks if king can move out of attacker's way
        elsif obj(square).is_a?(King)
          if obj(king).show_moves(self).any? { |move| checked? == false }
            pieces << "#{translate_from([king])}"
          end
        end
      end

      open_pieces
    end

    def save
      saved_game = YAML::dump(self)
      f = File.new("save.yaml", "w")
      f.puts saved_game
      f.close
    end

    def prompt_move_choice(coord)
      piece = @board[coord[0]][coord[1]]
      puts "#{piece.type}#{piece.color} can make the following moves: \n \n"
      moves = []
      print [piece, piece.show_moves(self)]
      piece.show_moves(self).each { |m| moves << translate_from(m) }
      print moves
      puts "\n"

      puts 'Please select your move, or type "cancel" to select another piece.'
      moves
    end

    def prompt_piece_choice(open_pieces)
      puts "\n\n"
      puts 'Player ' + "#{@turn}" + ', please select the piece you would like to move (or type "save" to save game.)'
      puts "\n"

      print open_pieces
      puts "\n\n"
    end

    def validate_piece(input, open_pieces)
      until open_pieces.include?(input) || open_pieces == input
        if input == "save" || input == "save game"
          save

          puts "Game saved. \n"
          puts "Player #{@turn}, please select the piece you would like to move."
          print open_pieces
          puts "\n"
          input = gets.chomp
        else
          puts "You do not have a piece at that location. Please select from the locations listed."
          print open_pieces
          puts "\n"
          input = gets.chomp
        end
      end
      input
    end

    def validate_available(input, moves)
      while moves.include?(input) == false
        puts 'The selected piece cannot move to that square. Please select another move or type "cancel" to select another piece.'
        puts "\n"
        print moves
        puts "\n"
        input = gets.chomp
      end
      input
    end

    # This needs to be re-factored.
    def validate_no_check(move, coord)
      @turn == "w" ? king = @w_king : king = @b_king

      piece = @board[coord[0]][coord[1]]
      case piece.type
      when "p" then dummy = Pawn.new(piece.r, piece.c, "p", piece.color)
      when "r" then dummy = Rook.new(piece.r, piece.c, "r", piece.color)
      when "h" then dummy = Knight.new(piece.r, piece.c, "h", piece.color)
      when "b" then dummy = Bishop.new(piece.r, piece.c, "b", piece.color)
      when "k" then dummy = King.new(piece.r, piece.c, "k", piece.color)
      when "q" then dummy = Queen.new(piece.r, piece.c, "q", piece.color)
      end

      @board[piece.r][piece.c] = " "
      @board[move[0]][move[1]] = piece
      piece.r = move[0]
      piece.c = move[1]

      # Test this.
      if checked? != false
        puts "\n"
        puts 'That move would put you in check. Please select another move or type "cancel" to select another piece.'
        @board[piece.r][piece.c] = " "
        @board[dummy.r][dummy.c] = dummy
        piece.r = dummy.r
        piece.c = dummy.c
        return move(piece)
      end
      if piece.class == Pawn then piece.promote(self) end
    end

    def translate_from(coordinate)
      alph = ('a'..'h').to_a

      coordinate[0] += 1
      coordinate[1] = alph[coordinate[1]]
      coordinate = coordinate.join
      coordinate
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
      coordinate
    end

    def obj(coord)
      @board[coord[0]][coord[1]]
    end
end