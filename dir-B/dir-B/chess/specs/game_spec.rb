require "C:/Users/John/the-odin-project/chess/lib/game"
require "C:/Users/John/the-odin-project/chess/lib/player"
require "C:/Users/John/the-odin-project/chess/lib/pawn"
require "C:/Users/John/the-odin-project/chess/lib/rook"
require "C:/Users/John/the-odin-project/chess/lib/knight"
require "C:/Users/John/the-odin-project/chess/lib/bishop"
require "C:/Users/John/the-odin-project/chess/lib/queen"
require "C:/Users/John/the-odin-project/chess/lib/king"

describe Game do

	let(:game) { Game.new }
	let(:player) { Player.new("b") }

	describe "#board" do

		it "is in an array" do
			expect(game.board).to be_instance_of(Array)
		end

		it "is in an empty array" do
			game.board = Array.new(8).map { Array.new(8).map! { |square| square = "  " } }

			expect(game.board.all? { |row| row.all? { |square| square == "  "} }).to be true
		end
	end

	describe "#move" do

		it "initializes piece in correct location" do
			game.board.each { |rows| rows.map! { |squares| squares = "  " } }
			game.board[0][0] = Rook.new(0, 0, "r", "b")
			
			expect(game.board[0][0]).to be_a Rook
		end
	end

	describe "#checked?" do

		let(:white_player) { Player.new("w") }
		let(:black_player) { Player.new("b") }
		let(:rook1) { Rook.new(5, 0, "r", "w") }
		let(:rook2) { Rook.new(3, 0, "r", "w") }
		let(:queen) { Queen.new(7, 6, "q", "w") }
		let(:king) { King.new(4, 7, "k", "b") }

		it "declares winner if king is in checkmate" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[2][6] = Pawn.new(2, 6, "p", "w")
			game.board[5][0] = rook1
			game.board[4][7] = king
			white_king = King.new(4, 5, "k", "w")
			game.board[4][5] = white_king
			white_knight = Knight.new(4, 4, "h", "w")
			game.board[4][4] = white_knight
			game.board[6][5] = Bishop.new(6, 5, "q", "w")
			game.board[1][3] = Queen.new(1, 3, "q", "b")

			game.instance_variable_set("@black_king", king)
			game.instance_variable_set("@white_knight1", white_knight)

			a_moves = game.checked?([king.row, king.column], black_player, white_player)

			expect(game.checkmate?(a_moves, white_player, black_player)).to eql("Checkmate! Player b loses!")
		end

		it "declares winner if king is in checkmate alt setup" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			king = King.new(2, 2, "k", "b")
			game.board[2][2] = king
			game.board[3][2] = Bishop.new(3, 2, "b", "w")
			game.board[4][3] = Bishop.new(4, 3, "b", "w")
			game.board[5][2] = Knight.new(5, 2, "h", "w")
			game.board[1][5] = Rook.new(1, 5, "r", "w")
			game.board[0][2] = Rook.new(0, 2, "r", "w")

			game.instance_variable_set("@black_king", king)

			a_moves = game.checked?([king.row, king.column], white_player, black_player)

			expect(game.checkmate?(a_moves, white_player, black_player)).to eql("Checkmate! Player b loses!")
		end

		it "tells player if king in check" do
			game = Game.new
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.instance_variable_set("@black_king", king)
			game.board[4][7] = king
			game.board[4][0] = Rook.new(4, 0, "r", "w")

			expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
		end

		it "recognizes if checked player can shield king" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[2][6] = Pawn.new(2, 6, "p", "w")
			game.board[5][0] = rook1
			game.board[4][7] = king
			white_king = King.new(4, 5, "k", "w")
			game.board[4][5] = white_king
			white_knight = Knight.new(4, 4, "h", "w")
			game.board[4][4] = white_knight
			game.board[6][5] = Bishop.new(6, 5, "q", "w")
			game.board[6][7] = Bishop.new(6, 7, "b", "b")

			game.instance_variable_set("@black_king", king)
			game.instance_variable_set("@white_king", white_king)
			game.instance_variable_set("@white_knight1", white_knight)

			expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
		end

		it "recognizes if king can take checking piece" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			king = King.new(2, 2, "k", "b")
			game.board[2][2] = king
			game.board[3][2] = Bishop.new(3, 2, "b", "w")
			game.board[4][3] = Queen.new(4, 3, "q", "w")
			game.board[5][2] = Knight.new(5, 2, "h", "w")
			game.board[1][2] = Rook.new(1, 2, "r", "w")

			game.instance_variable_set("@black_king", king)

			expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
		end

		it "recognizes if checked player can shield king alt setup" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			king = King.new(2, 2, "k", "b")
			game.board[2][2] = king
			game.board[0][1] = Bishop.new(0, 1, "b", "b")
			game.board[3][2] = Bishop.new(3, 2, "b", "w")
			game.board[4][3] = Queen.new(4, 3, "q", "w")
			game.board[5][2] = Knight.new(5, 2, "h", "w")
			game.board[1][5] = Rook.new(1, 5, "r", "w")
			game.board[0][2] = Rook.new(0, 2, "r", "w")

			game.instance_variable_set("@black_king", king)

			expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
		end

		it "recognizes if checked player can take checker piece" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[2][6] = Pawn.new(2, 6, "p", "w")
			game.board[5][0] = rook1
			game.board[4][7] = king
			white_king = King.new(4, 5, "k", "w")
			game.board[4][5] = white_king
			white_knight = Knight.new(4, 4, "h", "w")
			game.board[4][4] = white_knight
			game.board[6][5] = Bishop.new(6, 5, "q", "w")
			game.board[6][7] = Rook.new(6, 7, "r", "b")

			game.instance_variable_set("@black_king", king)
			game.instance_variable_set("@white_king", white_king)
			game.instance_variable_set("@white_knight1", white_knight)

			expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
		end

		it "does not make queen disappear" do
			game.board.each { |rows| rows.map! { |squares| squares = " " } }
			game.board[7][3] = Queen.new(7, 3, "q", "b")
    		game.board[3][0] = Queen.new(3, 0, "q", "w")
    		game.board[7][4] = King.new(7, 4, "k", "b")
    		game.board[0][4] = King.new(0, 4, "k", "w")
    		game.board[7][2] = Bishop.new(7, 2, "b", "b")
    		game.board[7][5] = Bishop.new(7, 5, "b", "b")
    		game.board[0][2] = Bishop.new(0, 2, "b", "w")
    		game.board[0][5] = Bishop.new(0, 5, "b", "w")
    		game.board[7][1] = Knight.new(7, 1, "h", "b")
    		game.board[7][6] = Knight.new(7, 6, "h", "b")
    		game.board[0][1] = Knight.new(0, 1, "h", "w")
    		game.board[0][6] = Knight.new(0, 6, "h", "w")
    		game.board[7][0] = Rook.new(7, 0, "r", "b")
    		game.board[7][7] = Rook.new(7, 7, "r", "b")
    		game.board[0][0] = Rook.new(0, 0, "r", "w")
    		game.board[0][7] = Rook.new(0, 7, "r", "w")

    		game.board[1][2] = " "
    		game.board[3][2] = Pawn.new(3, 2, "p", "w")
    		game.board[6][3] = " "
    		game.board[5][3] = Pawn.new(5, 3, "p", "b")

    		expect(game.checked?([king.row, king.column], white_player, black_player)).to be_instance_of(Array)
    	end

    it "recognize's fool's mate" do
			game = Game.new
			game.board[1][5] = " "
			game.board[1][6] = " "
			game.board[2][5] = Pawn.new(2, 5, "p", "w")
			game.board[3][6] = Pawn.new(3, 6, "p", "w")
			game.board[3][7] = Queen.new(3, 7, "q", "b")
			king = game.board[0][5]

			a_moves = game.checked?([king.row, king.column], black_player, white_player)

			expect(game.checkmate?(a_moves, black_player, white_player)).to eql("Checkmate! Player w loses!")
		end
	end
end