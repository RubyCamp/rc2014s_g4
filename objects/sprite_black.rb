module MapChips
  class Black < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/black.png")
      super
    end
  end
end
