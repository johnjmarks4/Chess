require "C:/Users/johnj/odin-project/chess/lib/game"
require "C:/Users/johnj/odin-project/chess/lib/player"
require "C:/Users/johnj/odin-project/chess/lib/pawn"
require "C:/Users/johnj/odin-project/chess/lib/rook"
require "C:/Users/johnj/odin-project/chess/lib/knight"
require "C:/Users/johnj/odin-project/chess/lib/bishop"
require "C:/Users/johnj/odin-project/chess/lib/queen"
require "C:/Users/johnj/odin-project/chess/lib/king"
require "C:/Users/johnj/odin-project/chess/lib/board"

describe Rook do

	let(:game) { Game.new }
	let(:rook) { Rook.new(0, 0, "r", "b") }
	let(:player) { Player.new("b") }

	describe "#show_moves" do

		it "shows positive vertical moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[0][0] = rook

			expect(rook.show_moves(game)).to include [0, 1]
			expect(rook.show_moves(game)).to include [0, 7]
		end

		it "shows positive horizontal moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[0][0] = rook

			expect(rook.show_moves(game)).to include [1, 0]
			expect(rook.show_moves(game)).to include [7, 0]
		end

		it "shows negative vertical moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			rook = Rook.new(7, 0, "r", "b")
			game.board[7][0] = rook

      print rook.show_moves(game)

			expect(rook.show_moves(game)).to include [6, 0]
			expect(rook.show_moves(game)).to include [0, 0]
		end

		it "shows negative horizontal moves" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			rook = Rook.new(7, 0, "r", "b")
			game.board[7][0] = rook

			expect(rook.show_moves(game)).to include [7, 1]
			expect(rook.show_moves(game)).to include [7, 7]
		end
	end
end