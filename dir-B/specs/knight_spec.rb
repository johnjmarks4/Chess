require "C:/Users/johnj/odin-project/chess/lib/game"
require "C:/Users/johnj/odin-project/chess/lib/player"
require "C:/Users/johnj/odin-project/chess/lib/pawn"
require "C:/Users/johnj/odin-project/chess/lib/rook"
require "C:/Users/johnj/odin-project/chess/lib/knight"
require "C:/Users/johnj/odin-project/chess/lib/bishop"
require "C:/Users/johnj/odin-project/chess/lib/queen"
require "C:/Users/johnj/odin-project/chess/lib/king"
require "C:/Users/johnj/odin-project/chess/lib/board"

describe Knight do

	let(:game) { Game.new }
	let(:knight) { Knight.new(4, 4, "b", "b") }
	let(:player) { Player.new("b") }

	describe "#show_moves" do

		it "shows moves in all directions" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[4][4] = knight

			expect(knight.show_moves(game)).to include [6, 5]
			expect(knight.show_moves(game)).to include [2, 5]
			expect(knight.show_moves(game)).to include [6, 3]
			expect(knight.show_moves(game)).to include [2, 3]
			expect(knight.show_moves(game)).to include [5, 6]
			expect(knight.show_moves(game)).to include [3, 6]
			expect(knight.show_moves(game)).to include [5, 2]
			expect(knight.show_moves(game)).to include [3, 2]
		end
	end
end