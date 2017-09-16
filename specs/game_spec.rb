require 'C:\Users\johnj\odin-project\chess2\lib\board.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\queen.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\king.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\pawn.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\bishop.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\rook.rb'
require 'C:\Users\johnj\odin-project\chess2\lib\knight.rb'

describe Board do

  let(:board) { Board.new }

  describe "#board" do

    it "recognizes fool's mate" do
      board.board[1][5] = " "
      board.board[1][6] = " "
      board.board[2][5] = Pawn.new(2, 5, "p", "w", board)
      board.board[3][6] = Pawn.new(3, 6, "p", "w", board)
      board.board[3][7] = Queen.new(3, 7, "q", "b", board)
      king = board.board[0][5]

      expect(board.checkmate?).to eql(true)
    end

    it "recognizes checkmate" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      king = King.new(2, 2, "k", "b", board)
      board.board[2][2] = king
      board.board[3][2] = Bishop.new(3, 2, "b", "w", board)
      board.board[4][3] = Bishop.new(4, 3, "b", "w", board)
      board.board[5][2] = Knight.new(5, 2, "h", "w", board)
      board.board[1][5] = Rook.new(1, 5, "r", "w", board)
      board.board[0][2] = Rook.new(0, 2, "r", "w", board)

      board.instance_variable_set("@turn", "b")
      board.instance_variable_set("@b_king", king)
      board.print_board

      expect(board.checkmate?).to eql(true)
    end

    it "tells player if king in check" do
      board = Board.new
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.instance_variable_set("@turn", "b")
      king = King.new(4, 7, "k", "b", board)
      board.board[4][7] = king
      board.instance_variable_set("@b_king", king)
      board.board[4][0] = Rook.new(4, 0, "r", "w", board)

      expect(board.in_check?).to eql(true)
    end
  end
end