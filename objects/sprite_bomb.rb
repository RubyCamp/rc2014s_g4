module MapChips
  class Bomb < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/bomb.png")
      super
    end
  end
end
  
