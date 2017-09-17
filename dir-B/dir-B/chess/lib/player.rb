class Player
  attr_accessor :color, :checked

  def initialize(color)
    @color = color
    @checked = false
  end
end