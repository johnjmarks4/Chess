require_relative "board"
require_relative "pawn"
require_relative "rook"
require_relative "knight"
require_relative "bishop"
require_relative "queen"
require_relative "king"

puts "Player please select new game or load game"

board = ""
while board == ""
  choice = gets.chomp
  if choice == "load" || choice == "load game"
    board = YAML.load File.read('save.yaml')
  elsif choice == "new" || choice == "new game"
    board = Board.new
  else
    puts 'Your input was not understood. Please try again. Type either "load" or "new game"'
  end
end

board.play