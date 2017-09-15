require_relative "piece"

class Knight < Piece

  def show_moves
    container = [[(@r + 2),(@c + 1)],
                 [(@r - 2),(@c + 1)],
                 [(@r + 2),(@c - 1)],
                 [(@r - 2),(@c - 1)],
                 [(@r + 1),(@c + 2)],
                 [(@r - 1),(@c + 2)],
                 [(@r + 1),(@c - 2)],
                 [(@r - 1),(@c - 2)]]

    container.select! { |x| x[0] <= 7 && x[0] >= 0 && x[1] <= 7 && x[1] >= 0 }
    container.reject! { |x| @board.board[x[0]][x[1]] != " " && @board.board[x[0]][x[1]].color == @color }
    container
  end
end