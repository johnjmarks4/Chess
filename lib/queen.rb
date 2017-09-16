require_relative 'piece'
require_relative 'modules'

class Queen < Piece
  include DiagonalMoves
  include RookMoves

  def show_moves
    @container = []
    asc_right
    asc_left
    desc_right
    desc_left

    right
    left
    up
    down
    
    @container.uniq
  end
end