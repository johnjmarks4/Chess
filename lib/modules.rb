module DiagonalMoves

  private

    def asc_right
      r = @r + 1
      c = @c + 1
      while r <= 7 && c <= 7
        break if can_take_piece?(@board.board[r][c])
        break if occupied?([r, c])
        @container << [r, c]
        c += 1
        r += 1
      end
      @container
    end

    def asc_left
      r = @r + 1
      c = @c - 1
      while r <= 7 && c >= 0
        break if can_take_piece?(@board.board[r][c])
        break if occupied?([r, c])
        @container << [r, c]
        c -= 1
        r += 1
      end
      @container
    end

    def desc_left
      r = @r - 1
      c = @c - 1
      while r >= 0 && c >= 0
        break if can_take_piece?(@board.board[r][c])
        break if occupied?([r, c])
        @container << [r, c]
        c -= 1
        r -= 1
      end
      @container
    end

    def desc_right
      r = @r - 1
      c = @c + 1
      while r >= 0 && c <= 7
        break if can_take_piece?(@board.board[r][c])
        break if occupied?([r, c])
        @container << [r, c]
        c += 1
        r -= 1
      end
      @container
    end
end

module RookMoves

  private

    def right
      c = @c + 1
      while c <= 7
        break if can_take_piece?(@board.board[@r][c])
        break if occupied?([r, c])
        @container << [@r, c]
        c += 1
      end
      @container
    end

    def left
      c = @c - 1
      while c >= 0
        break if can_take_piece?(@board.board[@r][c])
        break if occupied?([r, c])
        @container << [@r, c]
        c -= 1
      end
      @container
    end

    def up
      r = @r + 1
      while r <= 7
        break if can_take_piece?(@board.board[r][@c])
        break if occupied?([r, c])
        @container << [r, @c]
        r += 1
      end
      @container
    end

    def down
      r = @r - 1
      while r >= 0
        break if can_take_piece?(@board.board[r][@c])
        break if occupied?([r, c])
        @container << [r, @c]
        r -= 1
      end
      @container
    end
end