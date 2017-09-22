require 'C:\Users\johnj\odin-project\chess\lib\board.rb'
require 'C:\Users\johnj\odin-project\chess\lib\queen.rb'
require 'C:\Users\johnj\odin-project\chess\lib\king.rb'
require 'C:\Users\johnj\odin-project\chess\lib\pawn.rb'
require 'C:\Users\johnj\odin-project\chess\lib\bishop.rb'
require 'C:\Users\johnj\odin-project\chess\lib\rook.rb'
require 'C:\Users\johnj\odin-project\chess\lib\knight.rb'

describe Board do

  let(:board) { Board.new }

  describe "#board" do

    it "recognizes fool's mate" do
      board.board[1][5] = " "
      board.board[1][6] = " "
      board.board[2][5] = Pawn.new(2, 5, "w", board)
      board.board[3][6] = Pawn.new(3, 6, "w", board)
      board.board[3][7] = Queen.new(3, 7, "b", board)
      king = board.board[0][4]
      board.instance_variable_set("@turn", "w")
      board.instance_variable_set("@w_king", king)
      board.print_board

      expect(board.checkmate?).to eql(true)
    end

    it "recognizes checkmate" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      king = King.new(2, 2, "b", board)
      board.board[2][2] = king
      board.board[3][2] = Bishop.new(3, 2, "w", board)
      board.board[4][3] = Bishop.new(4, 3, "w", board)
      board.board[5][2] = Knight.new(5, 2, "w", board)
      board.board[1][5] = Rook.new(1, 5, "w", board)
      board.board[0][2] = Rook.new(0, 2, "w", board)

      board.instance_variable_set("@turn", "b")
      board.instance_variable_set("@b_king", king)

      expect(board.checkmate?).to eql(true)
    end

    it "tells player if king in check" do
      board = Board.new
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.instance_variable_set("@turn", "b")
      king = King.new(4, 7, "b", board)
      board.board[4][7] = king
      board.instance_variable_set("@b_king", king)
      board.board[4][0] = Rook.new(4, 0, "w", board)

      expect(board.in_check?).to eql(true)
    end

    it "recognizes if checked player can shield king" do
      board.board.each { |rows| rows.map! { |squares| squares = " " } }
      board.board[2][6] = Pawn.new(2, 6, "w", board)
      board.board[5][0] = Rook.new(5, 0, "b", board)
      king = King.new(4, 7, "b", board)
      board.board[4][7] = king
      white_king = King.new(4, 5, "w", board)
      board.board[4][5] = white_king
      white_knight = Knight.new(4, 4, "w", board)
      board.board[4][4] = white_knight
      board.board[6][5] = Bishop.new(6, 5, "w", board)
      board.board[6][7] = Bishop.new(6, 7, "b", board)

      board.instance_variable_set("@b_king", king)
      board.instance_variable_set("@w_king", white_king)
      board.instance_variable_set("@white_knight1", white_knight)

      expect(board.checkmate?).to eql(false)
    end

    it "recognizes if king can take checker" do
      board = Board.new
      board.board[6][3] = Pawn.new(6, 3, "w", board)
      board.instance_variable_set("@turn", "b")

      expect(board.in_check?).to eql(true)
      expect(board.checkmate?).to eql(false)
    end
  end
end