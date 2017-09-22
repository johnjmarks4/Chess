require_relative 'piece'

class Pawn < Piece

  def show_moves
    moves = []

    if on_board?([@r + 1, @c]) && @color == "w"
      moves << [@r + 1, @c] if !@board.board[@r+1][@c].is_a?(Piece)
    elsif on_board?([@r - 1, @c]) && @color == "b" 
      moves << [@r - 1, @c] if !@board.board[@r-1][@c].is_a?(Piece)
    end

    if starting_position?
      moves << [@r + 2, @c] if @color == "w" && @board.board[@r + 2][@c] == " "
      moves << [@r - 2, @c] if @color == "b" && @board.board[@r - 2][@c] == " "
    end

    diagonals = [[@r + 1, @c + 1], [@r + 1, @c - 1]] if @color == "w"
    diagonals = [[@r - 1, @c + 1], [@r - 1, @c - 1]] if @color == "b"
    diagonals.each do |m|
      next if m.any? { |n| n > 7 || n < 0 }
      square = @board.board[m[0]][m[1]]
      moves << m if can_take_piece?(square)
    end

    moves.reject! { |m| occupied?(m) }
    moves
  end

  def promote
    puts "One of your pawns has reached the back row. Type the piece you would like to trade it for: "
    puts "Queen, Bishop, Knight, or Rook."

    input = gets.chomp!

    if ["Queen", "Bishop", "Knight", "Rook"].include?(input.capitalize)
      Piece.const_get(input.capitalize).new(@r, @c, @color, @board)
    else
      puts "Your input was not understood."
      promote
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