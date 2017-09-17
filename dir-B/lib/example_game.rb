require_relative "game"
require_relative "player"
require_relative "pawn"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"
require_relative "board"

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

while game.winner == false
	pieces = game.open_pieces
  if pieces.empty?
    game.winner = true
    print "checkmate"
    break
  end
	game.move(pieces)
	#if game.checked? == true
		#game.winner = true if game.checkmate?
	#end
  game.switch_turn
	game.print_board
end