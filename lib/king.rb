require_relative 'piece'

class King < Piece

  def show_moves
    moves = [[@r+1, @c], [@r+1, @c+1], [@r, @c+1],
             [@r-1, @c+1], [@r-1, @c], [@r-1, @c-1],
             [@r, @c-1], [@r+1, @c-1]]

    moves.reject! do |m|
      on_board?(m) == false || occupied?(m)
    end

    castle
    moves
  end

  def castle
    routes = []
    routes << @board.draw_route([@r, @c], [0, 0]).reverse if @color == "w"
    routes << @board.draw_route([@r, @c], [0, 7]) if @color == "w"
    routes << @board.draw_route([@r, @c], [7, 0]).reverse if @color == "b"
    routes << @board.draw_route([@r, @c], [7, 7]) if @color == "b"

    routes.each do |r|
      r.map! { |s| @board.board[s.first][s.last] }
      if @color == "w" && @r == 0 && @c == 4 ||
         @color == "b" && @r == 7 && @c == 4

          if r[-1].is_a?(Rook) && 
             r[1..-2].all? { |s| s == " " } && 
             @total_moves == 0 &&
             r[-1].color == @color
             
             @board.can_castle << [self, r[-1]]

        end
      end
    end
  end
end