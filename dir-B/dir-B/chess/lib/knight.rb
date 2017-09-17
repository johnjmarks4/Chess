class Knight
  attr_accessor :row, :column, :type, :color, :unicode

  def initialize(row, column, type, color)
    @row = row
    @column = column
    @type = type
    @color = color
    @color == "w" ? @unicode = "\u265E" : @unicode = "\u2658"
  end

  def show_moves(game)
    container = [[(@row + 2),(@column + 1)],
                [(@row - 2),(@column + 1)],
                [(@row + 2),(@column - 1)],
                [(@row - 2),(@column - 1)],
                [(@row + 1),(@column + 2)],
                [(@row - 1),(@column + 2)],
                [(@row + 1),(@column - 2)],
                [(@row - 1),(@column - 2)]]

    container.select! { |x| x[0] <= 7 && x[0] >= 0 && x[1] <= 7 && x[1] >= 0 }
    container.reject! { |x| game.board[x[0]][x[1]] != " " && game.board[x[0]][x[1]].color == @color }
    container
  end
end