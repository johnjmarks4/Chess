require_relative 'piece'

class Pawn < Piece

  def show_moves(game)
    moves = []

    if on_board?([@r + 1, @c])
      moves << [@r + 1, @c] if @color == "w"
      moves << [@r - 1, @c] if @color == "b"
    end

    if starting_position?
      moves << [@r + 2, @c] if @color == "w"
      moves << [@r - 2, @c] if @color == "b"
    end

    diagonals = [[@r + 1, @c + 1], [@r + 1, @c - 1]] if @color == "w"
    diagonals = [[@r - 1, @c + 1], [@r - 1, @c - 1]] if @color == "b"
    diagonals.each do |m|
      next if m.any? { |n| n > 7 || n < 0 }
      square = game.board[m[0]][m[1]]
      moves << m if can_take_piece?(square)
    end

    moves.reject! { |m| occupied?(m, game) }
    moves
  end

  def promote(game)
    if @r == 7 || @r == 0
      print "One of your pawns has reached the back row. Type the letter for the piece \n
      you would like to trade it for: \nq = Queen\nb = Bishop\nk = Knight\nr = Rook\n"

      input = gets.chomp

      case input
      when "q"
        game.board[@r][@c] = Queen.new(@r, @c, "q", @color)
      when "b"
        game.board[@r][@c] = Bishop.new(@r, @c, "b", @color)
      when "k"
        game.board[@r][@c] = Knight.new(@r, @c, "h", @color)
      when "r"
        game.board[@r][@c] = Rook.new(@r, @c, "r", @color)
      else
        puts "Your input was not understood."
        promote(game)
      end
    end
  end

  private
  
    def starting_position?
      if @color == "b" 
        @r == 6
      elsif @color == "w" 
        @r == 1
      end
    end
end