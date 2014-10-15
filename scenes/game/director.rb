require_relative "map"
require_relative "state"
module Game
  class Director
    def initialize
      @map = Map.new
      @direction =
        {
        up: {x:0, y:-1},
        right: {x:1, y:0},
        down: {x:0, y:1},
        left: {x:-1,y:0}
      }

      @image_filter = Image.new(Window.width,Window.height)
      @state = State.new
    end

    attr_accessor :state

    def play
      player = @map.player
      walls  = @map.walls
      lamps = @map.lamps
      shoes = @map.shoes
      x = Input.x
      y = Input.y

      next_x = player.x + x * Map::CHIP_W
      next_y = player.y + y * Map::CHIP_H
      current_x = player.x
      current_y = player.y
      @map.delete_chip(current_x, current_y)

      next_chip = @map.get_chip(next_x, next_y)

      case next_chip.class.to_s
      when "MapChips::Wall"
        player.set_direction({x:x, y:y})

      when "MapChips::Lamp"
        player.use_lamp(next_chip)
        player.acquire_item(next_chip)
        player.walk({x:x, y:y})

      when "MapChips::Shoes"
        player.use_shoes(next_chip)
        player.acquire_item(next_chip)
        player.walk({x:x, y:y})

      when "MapChips::Goal"
        Scene.get_scene(:ending).set_time(@state.get_time)
        Scene.set_current_scene(:ending)
      else
        player.walk({x:x, y:y})
      end
      @map.set_chip(player)


      if Input.keyPush?(K_B) and player.item_count[:"MapChips::Bomb"].to_i != 0
        wall_x = player.x + @direction[player.direction][:x] * Map::CHIP_W
        wall_y = player.y + @direction[player.direction][:y] * Map::CHIP_H
        if @map.get_chip(wall_x, wall_y).class.to_s == "MapChips::Wall"
          player.use_bomb
          @map.delete_chip(wall_x, wall_y)
        end
      end


      @image_filter.fill([0,0,0])
      ImageFilter.circle(@image_filter,player.x,player.y,player.r)
      ImageFilter.box(@image_filter, 600, 0, 800, 600)

      @map.draw
      @state.draw(player)
      Window.draw(0, 0, @map.image)
      Window.draw(600, 0, @state.image)
      Window.draw(0, 0, @image_filter)

      wait(player)

    end
    def wait(player)
      shoes_count = player.item_count[:shoes].to_i + 1
      sleep(0.1/shoes_count)
    end
  end
end
