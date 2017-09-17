class Bishop
  attr_accessor :row, :column, :type, :color, :unicode

  def initialize(row, column, type, color)
    @row = row
    @column = column
    @type = type
    @color = color
    @color == "w" ? @unicode = "\u265D" : @unicode = "\u2657"
  end

  def show_moves(game)
    container = []

    #descending-right

    row = @row + 1
    column = @column + 1
    while row <= 7 && column <= 7 && game.board[row][column] == " " || row <= 7 && column <= 7 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column += 1
      row += 1
    end

    #ascending-left

    row = @row + 1
    column = @column - 1
    while row <= 7 && column >= 0 && game.board[row][column] == " " || row <= 7 && column >= 0 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column -= 1
      row += 1
    end

    #descending-left

    row = @row - 1
    column = @column - 1
    while row >= 0 && column >= 0 && game.board[row][column] == " " || row >= 0 && column >= 0 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column -= 1
      row -= 1
    end

    #descending-right

    row = @row - 1
    column = @column + 1
    while row >= 0 && column <= 7 && game.board[row][column] == " " || row >= 0 && column <= 7 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column += 1
      row -= 1
    end

    container
  end
end