class Map
  CHIP_W = 16
  CHIP_H = 16

  attr_accessor :draw_items, :walls, :player, :shoes, :lamps, :image

  def initialize
    @canvas = RenderTarget.new(800,600)
    @chips = []
    @chips << MapChips::Black
    @chips << MapChips::Wall
    @chips << MapChips::Shoes
    @chips << MapChips::Lamp
    @chips << MapChips::Player
    @chips << MapChips::Goal
    @map_data = Array.new(37).map{Array.new(37,1)}
    @map = @map_data.map do |row|
      row.map{|i| @chips[i].new(0, 0)}
    end   
    @memory = []
    make_maze

    @vp_x = 0
    @vp_y = 0
    @draw_items = [] 

    @walls = @map.map {|row|
      row.select {|item| item.class.to_s == "MapChips::Wall"}
    }
    @player = MapChips::Player.new(0,0)
    @lamps = 2.times.map{ MapChips::Lamp.new(0,0) }
    @shoes = 4.times.map{ MapChips::Shoes.new(0,0) }
    @goal = MapChips::Goal.new(0,0)

    add_items([@player])
    add_items(@lamps)
    add_items(@shoes)
    add_items([@goal])
    @player.item_count["MapChips::Bomb".to_sym] = 3

    @image = Image.new(Window.width, Window.height)
  end

  def add_items(items)
    items.each {|item| 
      x,y = @memory.shuffle.first
      item.x = x
      item.y = y
      redo if @map[y][x].class.to_s != "MapChips::Black"

      @map[y][x] = item
    }
  end

  def delete_chip(x,y)
    x = map_x(x)
    y = map_y(y)

    @map[y][x] = MapChips::Black.new(x,y)

  end

  def set_chip(chip)
    x = map_x(chip.x)
    y = map_y(chip.y)

    @map[y][x] = chip

  end
  def set_map_chip(chip)
    @map[chip.y][chip.x] = chip
  end
  def get_chip(x,y)
    @map[map_y(y)][map_x(x)]
  end

  #  def get_pos(x, y)
  #   return @map[y][x]
  #end

  def draw
    @draw_items = []
    map_x(@vp_x).upto(map_x(@vp_x + @canvas.width)) do |m_x|
      map_y(@vp_y).upto(map_y(@vp_y + @canvas.height)) do |m_y|
        next unless @map[m_y]
        x = (m_x - map_x(@vp_x)) * CHIP_W - offset_px_x(@vp_x)
        y = (m_y - map_y(@vp_y)) * CHIP_H - offset_px_y(@vp_y)
        chip = @map[m_y][m_x]
        next unless chip
        chip.x = x
        chip.y = y
        @draw_items << chip
      end
    end
    # Sprite.draw(@draw_items)
    @draw_items.each {|draw_item|
      @image.draw(draw_item.x, draw_item.y, draw_item.image)
    }
  end

  def conv_map_pos(x, y)
    return [map_x(x), map_y(y)]
  end

  def map_x(x)
    return x.to_i / CHIP_W
  end

  def map_y(y)
    return y.to_i / CHIP_H
  end

  private

  def make_maze
    base_x = rand(@map[0].size - 3) + 1
    base_y = rand(@map.size - 3) + 1
    @map[base_y][base_x] = @chips[0].new(0, 0)
    @memory.push([ base_y, base_x])
    num = (@map.size * @map[0].size) * 10

    num.times do
      results = []
      a = rand(4)
      case a
      when 0
        base_x, res = make_road_right(base_x, base_y)
        results << res
      when 1
        base_y, res = make_road_up(base_x, base_y)
        results << res
      when 2
        base_x, res = make_road_left(base_x, base_y)
        results << res
      when 3
        base_y, res = make_road_down(base_x, base_y)
        results << res
      end
      if results.uniq == [false]
        pos = @memory.shuffle.first
        base_y, base_x = pos
        redo
      end
    end
  end

  def map_x(x)
    return x.to_i / CHIP_W
  end

  def map_y(y)
    return y.to_i / CHIP_H
  end

  def offset_px_x(x)
    return x.to_i % CHIP_W
  end

  def offset_px_y(y)
    return y.to_i % CHIP_H
  end


  def make_road_right(x, y)
    result = false
    2.times do
      if @map[y] && @map[y][x + 2].is_a?(MapChips::Wall) && @map[y - 1][x + 1].is_a?(MapChips::Wall) && @map[y + 1][x + 1].is_a?(MapChips::Wall)
        unless x >= @map[0].size
          @map[y][x + 1] = @chips[0].new(0, 0)
          @memory.push([ y, x])
          x += 1
          result = true
        end
      end
    end
    return x, result
  end

  def make_road_left(x, y)
    result = false
    2.times do
      if @map[y] && @map[y][x - 2].is_a?(MapChips::Wall) && @map[y + 1][x - 1].is_a?(MapChips::Wall) && @map[y - 1][x - 1].is_a?(MapChips::Wall)
        unless x <= 1
          @map[y][x - 1] = @chips[0].new(0, 0)
          @memory.push([ y, x])
          x -= 1
          result = true
        end
      end
    end
    return x, result
  end

  def make_road_up(x, y)
    result = false
    2.times do
      if @map[y - 2] && @map[y - 2][x].is_a?(MapChips::Wall) && @map[y - 1][x + 1].is_a?(MapChips::Wall) && @map[y - 1][x - 1].is_a?(MapChips::Wall)
        unless y <= 1
          @map[y - 1][x] = @chips[0].new(0, 0)
          @memory.push([ y, x])
          y -= 1
          result = true
        end
      end
    end
    return y, result
  end

  def make_road_down(x, y)
    result = false
    2.times do
      if @map[y + 2] && @map[y + 2][x].is_a?(MapChips::Wall) && @map[y + 1][x - 1].is_a?(MapChips::Wall) && @map[y + 1][x + 1].is_a?(MapChips::Wall)
        unless y >= @map.size
          @map[y + 1][x] = @chips[0].new(0, 0)
          @memory.push([ y, x])
          y += 1
          result = true
        end
      end
    end
    return y, result
  end
end
