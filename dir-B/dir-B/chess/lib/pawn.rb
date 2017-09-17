class Pawn
	attr_accessor :row, :column, :type, :color, :unicode

	def initialize(row, column, type, color)
		@row = row
		@column = column
		@type = type
		@color = color
    @color == "w" ? @unicode = "\u265F" : @unicode = "\u2659"
	end

  def show_moves(game)

    possible_moves = []

    if @color == "w"

      if @row == 1
        unless @row + 2 > 7 || game.board[@row + 2][@column] != " "
          possible_moves << [@row + 2, @column]
        end
      end

      unless @row + 1 > 7 || game.board[@row + 1][@column] != " " 
        possible_moves << [@row + 1, @column]
      end

      #can take enemy pieces?
      unless @row + 1 > 7 || @column + 1 > 7
        if game.board[@row + 1][@column + 1] != " " && game.board[@row +1][@column + 1].color == "b"
          possible_moves << [@row + 1, @column + 1]
        end
      end

      unless @row + 1 > 7 || @column - 1 < 0
        if game.board[@row + 1][@column - 1] != " " && game.board[@row +1][@column - 1].color == "b"
          possible_moves << [@row + 1, @column - 1]
        end
      end
    end

    if @color == "b"

      if @row == 6
        unless @row - 2 < 0 || game.board[@row - 2][@column] != " "
          possible_moves << [@row - 2, @column]
        end
      end

      unless @row - 1 < 0 || game.board[@row - 1][@column] != " " 
        possible_moves << [@row - 1, @column]
      end


      #can take enemy pieces?
      unless @row - 1 < 0 || @column + 1 > 7
        if game.board[@row - 1][@column + 1] != " " && game.board[@row - 1][@column + 1].color == "w"
          possible_moves << [@row - 1, @column + 1]
        end
      end

      unless @row - 1 < 0 || @column - 1 < 0
        if game.board[@row - 1][@column - 1] != " " && game.board[@row - 1][@column - 1].color == "w"
          possible_moves << [@row - 1, @column - 1]
        end
      end
    end

    return possible_moves
  end
end