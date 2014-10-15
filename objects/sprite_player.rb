module MapChips
  class Player < Sprite

    def initialize(x, y, image = nil)
      image = Image.load("images/player_down.png")
      super
      @dx = 1
      @dy = 1
      @r = 64
      @item_count= Hash.new
      @direction = :down
    end

    attr_reader :item_count, :direction, :r

    def acquire_item(item)
      @item_count[item.class.name.to_sym] ||= 0
      @item_count[item.class.name.to_sym] += 1
    end

    def set_direction(direction)
      if direction[:x] == 0 and direction[:y] == -1
        @direction = :up
      elsif direction[:x] == 1 and direction[:y] == 0
        @direction = :right
      elsif direction[:x] == 0 and direction[:y] == 1
        @direction = :down
      elsif direction[:x] == -1 and direction[:y] == 0
        @direction = :left
      end
      self.image = Image.load("images/player_#{@direction.to_s}.png")

    end

    def walk(direction) 
      set_direction(direction)

      return if direction[:x] * direction[:y] != 0

      self.x = self.x + direction[:x] * Map::CHIP_W
      self.y = self.y + direction[:y] * Map::CHIP_H
    end

    def use_bomb
      @item_count[:"MapChips::Bomb"] -= 1
    end

    def use_lamp(lamp)
      @r += lamp.dr
    end

    def use_shoes(shoes)
      @dx += shoes.a
      @dy += shoes.a
    end

  end
end
