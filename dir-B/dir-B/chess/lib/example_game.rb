require_relative "game"
require_relative "player"
require_relative "pawn"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"

game = ''

puts 'Please type either "load" or "new game"'

while game == ''
	choice = gets.chomp
	if choice == "load" || choice == "load game"
		game = YAML.load File.read('save.yaml')
	elsif choice == "new" || choice == "new game"
		game = Game.new
	else
		puts 'Your input was not understood. Please try again. Type either "load" or "new game"'
	end
end

game.print_board
player_black = game.make_player("b")
player_white = game.make_player("w")

while game.winner == false
	piece_menu = game.piece_menu(player_white)
	piece = game.pick_piece(player_white, piece_menu)
	while game.move(player_white, piece) == "cancel"
		piece = game.pick_piece(player_white, piece_menu)
	end
	game.promote_pawn(player_white)
	a_moves = game.checked?([game.black_king.row, game.black_king.column], player_white, player_black)
	if player_black.checked == true
		game.checkmate?(a_moves, player_white, player_black)
	end
	game.print_board

	break if game.winner == true

	piece_menu = game.piece_menu(player_black)
	piece = game.pick_piece(player_black, piece_menu)
	while game.move(player_black, piece) == "cancel"
		piece = game.pick_piece(player_black, piece_menu)
	end
	game.promote_pawn(player_black)
	a_moves = game.checked?([game.white_king.row, game.white_king.column], player_black, player_white)
	if player_white.checked == true
		game.checkmate?(a_moves, player_black, player_white)
	end
	game.print_board
end