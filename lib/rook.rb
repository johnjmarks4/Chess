require_relative 'piece'
require_relative 'modules'

class Rook < Piece
  include RookMoves

  def initialize(row, column, color, board)
    super
    @total_moves = 0
  end

  def show_moves
    @container = []
    right
    left
    up
    down
    
    @container.uniq
  end
end