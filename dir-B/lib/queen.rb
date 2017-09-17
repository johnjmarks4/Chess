require_relative 'piece'
require_relative 'diagonal_moves'
require_relative 'rook_moves'

class Queen < Piece
  include DiagonalMoves
  include RookMoves

  def show_moves(game)
    asc_right(game)
    asc_left(game)
    desc_right(game)
    desc_left(game)

    right(game)
    left(game)
    up(game)
    down(game)
    
    @container.uniq
  end
end