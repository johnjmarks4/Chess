class King
  attr_accessor :row, :column, :type, :color, :unicode

  def initialize(row, column, type, color)
    @row = row
    @column = column
    @type = type
    @color = color
    #NOTE: These unicode numbers should actually be reversed, but this displays correctly in DejaVu Sans Mono.
    @color == "w" ? @unicode = "\u265A" : @unicode = "\u2654"
  end

  def show_moves(game)
    container = []

    unless @row + 1 > 7 || game.board[@row + 1][@column].class != String && game.board[@row + 1][@column].color == @color
      container << [@row + 1, @column]
    end

    unless @row - 1 < 0 || game.board[@row - 1][@column].class != String && game.board[@row - 1][@column].color == @color
      container << [@row - 1, @column]
    end

    unless @column + 1 > 7 || game.board[@row][@column + 1].class != String && game.board[@row][@column + 1].color == @color
      container << [@row, @column + 1]
    end

    unless @column - 1 < 0 || game.board[@row][@column - 1].class != String && game.board[@row][@column - 1].color == @color
      container << [@row, @column - 1]
    end

    #diagonal left-ascending
    unless @row - 1 < 0 || @column - 1 < 0 || game.board[@row - 1][@column - 1].class != String && game.board[@row - 1][@column - 1].color == @color
      container << [@row - 1, @column - 1]
    end

    #diagonal left-descending
    unless @row + 1 > 7 || @column -1 < 0 || game.board[@row + 1][@column - 1].class != String && game.board[@row + 1][@column - 1].color == @color
      container << [@row + 1, @column - 1]
    end

    #diagonal right-ascending
    unless @row - 1 < 0 || @column + 1 > 7 || game.board[@row - 1][@column + 1].class != String && game.board[@row - 1][@column + 1].color == @color
      container << [@row - 1, @column + 1]
    end

    #diagonal right-descending
    unless @row + 1 > 7 || @column + 1 > 7 || game.board[@row + 1][@column + 1].class != String && game.board[@row + 1][@column + 1].color == @color
      container << [@row + 1, @column + 1]
    end

    container
  end
end
