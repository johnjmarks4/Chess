require_relative 'modules'
require_relative 'piece'

class Bishop < Piece
  include DiagonalMoves

  def show_moves(game)
    asc_right(game)
    asc_left(game)
    desc_right(game)
    desc_left(game)
    
    @container.uniq
  end
end