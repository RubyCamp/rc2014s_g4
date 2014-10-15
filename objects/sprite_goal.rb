module MapChips
  class Goal < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/goal.png")
      super
    end
  end
end
