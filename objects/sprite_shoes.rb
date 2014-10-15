module MapChips
  class Shoes < Sprite
    def initialize(x, y, image = nil)
      image = Image.load("images/shoes.png")
      super
      @a = 1   
    end
    attr_reader :a
  end
end
