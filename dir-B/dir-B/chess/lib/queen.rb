class Queen
  attr_accessor :row, :column, :type, :color, :unicode

  def initialize(row, column, type, color)
    @row = row
    @column = column
    @type = type
    @color = color
    @color == "w" ? @unicode = "\u265B" : @unicode = "\u2655" 
  end

  def show_moves(game)
    container = []

    #Bishop-like moves

    #descending-right

    row = @row + 1
    column = @column + 1
    while row <= 7 && column <= 7 && game.board[row][column] == " " || row <= 7 && column <= 7 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column += 1
      row += 1
    end

    #descending-left

    row = @row + 1
    column = @column - 1
    while row <= 7 && column >= 0 && game.board[row][column] == " " || row <= 7 && column >= 0 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column -= 1
      row += 1
    end

    #ascending-left

    row = @row - 1
    column = @column - 1
    while row >= 0 && column >= 0 && game.board[row][column] == " " || row >= 0 && column >= 0 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column -= 1
      row -= 1
    end

    #ascending-right

    row = @row - 1
    column = @column + 1
    while row >= 0 && column <= 7 && game.board[row][column] == " " || row >= 0 && column <= 7 && game.board[row][column].class != String && game.board[row][column].color != @color
      container << [row, column]
      break if game.board[row][column].class != String && game.board[row][column].color != @color
      column += 1
      row -= 1
    end

    #Rook-like moves

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