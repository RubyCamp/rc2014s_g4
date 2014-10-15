class State
  def initialize
    @color = [123, 104, 238]
    @image = Image.new(200, 600, @color)
    @font = Font.new(16)
    @player
    @time_image = Image.new(200, 28)
    @explain_image = Image.load("images/explain.png")

    @start_time = Time.now.to_i
  end 

  attr_reader :image
  attr_accessor :start_time

  def draw(player)
    @player = player
    @image.fill(@color)
    @image.draw(10, 10, create_image("lamp"))
    @image.draw(10, 38, create_image("shoes"))
    @image.draw(10, 66, create_image("bomb"))
    @time_image.draw_font(0, 0, "経過時間 " + get_time(), @font)
    @image.draw(10,100, @time_image)
    @image.draw(10,400,@explain_image)
    @time_image.clear

  end

  def create_image(item_name)
    class_name = "MapChips::#{item_name.capitalize}"
    item_count = @player.item_count[class_name.to_sym].to_i

    image = Image.new(60,28)
    image.draw(6, 6, Image.load("images/#{item_name}.png"))
    image.draw_font(28, 6, item_count.to_s, @font)
    image
  end

  def get_time
    diff_time = Time.now.to_i - @start_time
    minute = diff_time / 60
    second = diff_time % 60

    sprintf("%02d:%02d",minute, second)
  end

end
