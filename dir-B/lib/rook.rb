require_relative 'piece'
require_relative 'rook_moves'

class Rook < Piece
  include RookMoves

  def show_moves(game)
    right(game)
    left(game)
    up(game)
    down(game)
    
    @container.uniq
  end
end