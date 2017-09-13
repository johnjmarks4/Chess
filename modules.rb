module DiagonalMoves

  private

    def asc_right(game)
      r = @r + 1
      c = @c + 1
      while r <= 7 && c <= 7
        break if can_take_piece?(game.board[r][c])
        @container << [r, c]
        c += 1
        r += 1
      end
      @container
    end

    def asc_left(game)
      r = @r + 1
      c = @c - 1
      while r <= 7 && c >= 0
        break if can_take_piece?(game.board[r][c])
        @container << [r, c]
        c -= 1
        r += 1
      end
      @container
    end

    def desc_left(game)
      r = @r - 1
      c = @c - 1
      while r >= 0 && c >= 0
        break if can_take_piece?(game.board[r][c])
        @container << [r, c]
        c -= 1
        r -= 1
      end
      @container
    end

    def desc_right(game)
      r = @r - 1
      c = @c + 1
      while r >= 0 && c <= 7
        break if can_take_piece?(game.board[r][c])
        @container << [r, c]
        c += 1
        r -= 1
      end
      @container
    end
end

module RookMoves

  private

    def right(game)
      c = @c + 1
      while c <= 7
        break if can_take_piece?(game.board[@r][c])
        @container << [@r, c]
        c += 1
      end
      @container
    end

    def left(game)
      c = @c - 1
      while c >= 0
        break if can_take_piece?(game.board[@r][c])
        @container << [@r, c]
        c -= 1
      end
      @container
    end

    def up(game)
      r = @r + 1
      while r <= 7
        break if can_take_piece?(game.board[r][@c])
        @container << [r, @c]
        r += 1
      end
      @container
    end

    def down(game)
      r = @r - 1
      while r >= 0
        break if can_take_piece?(game.board[r][@c])
        @container << [r, @c]
        r -= 1
      end
      @container
    end
end