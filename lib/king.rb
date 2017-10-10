require_relative 'piece'

class King < Piece

  def initialize(row, column, color, board)
    super
    @total_moves = 0
  end

  def show_moves
    moves = [[@r+1, @c], [@r+1, @c+1], [@r, @c+1],
             [@r-1, @c+1], [@r-1, @c], [@r-1, @c-1],
             [@r, @c-1], [@r+1, @c-1]]

    moves.reject! do |m|
      on_board?(m) == false || occupied?(m)
    end

    moves
  end
end