module MapChips
  class Lamp < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/lamp.png")
      super
      @dr = 24
    end
    attr_reader :dr
  end
end
