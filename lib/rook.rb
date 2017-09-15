require_relative 'piece'
require_relative 'modules'

class Rook < Piece
  include RookMoves

  def show_moves
    right
    left
    up
    down
    
    @container.uniq
  end
end