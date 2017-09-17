class Rook
  attr_accessor :row, :column, :type, :color, :unicode

  def initialize(row, column, type, color)
    @row = row
    @column = column
    @type = type
    @color = color
    @color == "w" ? @unicode = "\u265C" : @unicode = "\u2656"
  end

  def show_moves(game)
    container = []

    column = @column + 1
    while column <= 7 && game.board[@row][column] == " " || column <= 7 && game.board[@row][column].class != String && game.board[@row][column].color != @color
      container << [@row, column]
      break if game.board[@row][column].class != String && game.board[@row][column].color != @color
      column += 1
    end

    column = @column - 1
    while column >= 0 && game.board[@row][column] == " " || column >= 0 && game.board[@row][column].class != String && game.board[@row][column].color != @color
      container << [@row, column]
      break if game.board[@row][column].class != String && game.board[@row][column].color != @color
      column -= 1
    end

    row = @row + 1
    while row <= 7 && game.board[row][@column] == " " || row <= 7 && game.board[row][@column].class != String && game.board[row][@column].color != @color
      container << [row, @column]
      break if game.board[row][@column].class != String && game.board[row][@column].color != @color
      row += 1
    end

    row = @row - 1
    while row >= 0 && game.board[row][@column] == " " || row >= 0 && game.board[row][@column].class != String && game.board[row][@column].color != @color
      container << [row, @column]
      break if game.board[row][@column].class != String && game.board[row][@column].color != @color
      row -= 1
    end

    container
  end
end