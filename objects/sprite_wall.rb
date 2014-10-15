module MapChips
  class Wall < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/wall.png")
      super
    end
  end
end
