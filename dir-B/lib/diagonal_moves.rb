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