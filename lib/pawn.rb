require_relative 'piece'

class Pawn < Piece
  attr_accessor :ep_pawn

  def first_move?
    true if @total_moves < 2
  end

  def show_moves
    moves = []

    ep = en_passant
    if !ep.empty?
      ep.each { |e| moves << e }
    else
      @ep_pawn = []
    end

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

    def en_passant
      @color == "w" ? r = 4 : r = 2
      con = []
      if @r == r
        c = @c + 1
        2.times do
          square = @board.board[r][c]
          square.is_a?(Pawn) && square.first_move?

          if  square.is_a?(Pawn) &&
              square.color != @color &&
              square.first_move?

            con << [r+1, c]
          end
          c = @c - 1
        end
      end
      if !con.empty?
        con.each { |m| @ep_pawn << m }
      end
      con
    end

    def starting_position?
      if @color == "b"
        @r == 6
      elsif @color == "w"
        @r == 1
      end
    end
end