require_relative 'piece'
require_relative 'modules'

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