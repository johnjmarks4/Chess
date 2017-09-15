require_relative 'modules'
require_relative 'piece'

class Bishop < Piece
  include DiagonalMoves

  def show_moves
    asc_right
    asc_left
    desc_right
    desc_left
    
    @container.uniq
  end
end