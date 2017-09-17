describe King do

	let(:game) { Game.new }
	let(:king) { King.new(6, 4, "k", "b") }

	describe "#show_moves" do

		it "shows horizontal, vertical, and diagonal moves" do
			game.board.each { |rows| rows.map! { |squares| squares = "  " } }
			game.board[6][4] = king

			expect(king.show_moves(game)).to include [7, 4]
			expect(king.show_moves(game)).to include [5, 4]
			expect(king.show_moves(game)).to include [6, 5]
			expect(king.show_moves(game)).to include [6, 3]
			expect(king.show_moves(game)).to include [5, 3]
			expect(king.show_moves(game)).to include [7, 5]
		end

		it "cannot move to square occupied by own color" do
			game.board.each { |rows| rows.map! { |squares| squares = "  " } }
			game.board[6][5] = Queen.new(6, 5, "q", "b")
			game.board[6][4] = king

			expect(king.show_moves(game)).not_to include [6, 5]
		end
	end
end