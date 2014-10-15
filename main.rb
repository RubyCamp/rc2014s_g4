require "dxruby"

print "\e[32m"
p "Now Loading..."
print "\e[0m"

Window.width = 800
Window.height = 600
Window.caption = "しまねっこの冒険"

require_relative "objects/sprite_black"
require_relative "objects/sprite_bomb"
require_relative "objects/sprite_wall"
require_relative "objects/sprite_shoes"
require_relative "objects/sprite_player"
require_relative "objects/sprite_goal"
require_relative "objects/sprite_lamp"

require_relative "scene"
require_relative "scenes/load_scenes"
require_relative "scenes/game/map"
require_relative "scenes/game/director"
require_relative "scenes/game/image_filter"
require_relative "scenes/game/state"

Scene.set_current_scene(:title)

Window.loop do
  break if Input.keyPush?(K_ESCAPE)

  Scene.play_scene
end
