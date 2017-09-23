require_relative 'piece'
require_relative 'modules'

class Rook < Piece
  include RookMoves

  def show_moves
    @container = []
    right
    left
    up
    down
    castle
    
    @container.uniq
  end

  def castle
    # Make sure it only accepts first moves
    route = @board.draw_route([@r, @c], [0, 4]) if @color == "w"
    route = @board.draw_route([@r, @c], [7, 4]) if @color == "b"
    route.map! { |s| @board.board[s.first][s.last] }

    if @color == "w" && @r == 0 && @c == 0 ||
       @color == "w" && @r == 0 && @c == 7 ||
       @color == "b" && @r == 7 && @c == 0 ||
       @color == "b" && @r == 7 && @c == 7
       
      if route[-1].is_a?(King) && 
         route[1..-2].all? { |s| s == " " } && 
         route[-1].color == @color

        @board.can_castle = [route[-1], self]
      end
    end
  end
end