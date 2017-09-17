require "C:/Users/johnj/odin-project/chess/lib/game"
require "C:/Users/johnj/odin-project/chess/lib/player"
require "C:/Users/johnj/odin-project/chess/lib/pawn"
require "C:/Users/johnj/odin-project/chess/lib/rook"
require "C:/Users/johnj/odin-project/chess/lib/knight"
require "C:/Users/johnj/odin-project/chess/lib/bishop"
require "C:/Users/johnj/odin-project/chess/lib/queen"
require "C:/Users/johnj/odin-project/chess/lib/king"
require "C:/Users/johnj/odin-project/chess/lib/board"

describe Queen do

	let(:game) { Game.new }
	let(:queen) { Queen.new(0, 0, "b", "b") }
	let(:player) { Player.new("b") }

	describe "#show_moves" do

		#bishop-like moves

		it "shows descending-right moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[0][0] = queen

			expect(queen.show_moves(game)).to include [1, 1]
			expect(queen.show_moves(game)).to include [7, 7]
		end

		it "shows descending-left moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(0, 7, "b", "b")
			game.board[0][7] = queen

			expect(queen.show_moves(game)).to include [1, 6]
			expect(queen.show_moves(game)).to include [7, 0] #some of these are redundant
		end

		it "shows ascending-left moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(7, 7, "b", "b")
			game.board[7][7] = queen

			expect(queen.show_moves(game)).to include [6, 6]
			expect(queen.show_moves(game)).to include [0, 0]
		end

		it "shows ascending-right moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(7, 0, "b", "b")
			game.board[7][0] = queen

			expect(queen.show_moves(game)).to include [6, 1]
			expect(queen.show_moves(game)).to include [0, 7]
		end

		#Rook-like moves

		it "shows positive vertical moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(0, 0, "b", "b")
			game.board[0][0] = queen

			expect(queen.show_moves(game)).to include [0, 1]
			expect(queen.show_moves(game)).to include [0, 7]
		end

		it "shows positive horizontal moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(0, 0, "b", "b")
			game.board[0][0] = queen

			expect(queen.show_moves(game)).to include [1, 0]
			expect(queen.show_moves(game)).to include [7, 0]
		end

		it "shows negative vertical moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(7, 0, "r", "b")
			game.board[7][0] = queen

			expect(queen.show_moves(game)).to include [6, 0]
			expect(queen.show_moves(game)).to include [0, 0]
		end

		it "shows negative horizontal moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			queen = Queen.new(7, 0, "r", "b")
			game.board[7][0] = queen

			expect(queen.show_moves(game)).to include [7, 1]
			expect(queen.show_moves(game)).to include [7, 7]
		end
	end
end