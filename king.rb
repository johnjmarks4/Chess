require_relative 'piece'

class King < Piece

  def show_moves(game)
    moves = [[@r+1, @c], [@r+1, @c+1], [@r, @c+1],
             [@r-1, @c+1], [@r-1, @c], [@r-1, @c-1],
             [@r, @c-1], [@r+1, @c-1]]

    moves.reject! do |m|
      on_board?(m) == false || occupied?(m, game)
    end

    moves
  end
end