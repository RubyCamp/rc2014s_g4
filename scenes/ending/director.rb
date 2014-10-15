module Ending
	class Director

		def initialize
		@bg_img = Image.load("images/takarabako.png")
		@shimanekko = Image.load("images/shimanekko2.png")
		@bg_img.draw_font(300, 200, "クリア", Font.new(128), [255, 0 ,0])
        @time
		end

		def play
			Window.draw(100, 0, @bg_img, 1)
			Window.bgcolor = [255, 255, 255]
			Window.draw(200, 200, @shimanekko, 2)
            @bg_img.draw_font(350, 330, "タイム #{@time}", Font.new(32), [0,0,255])
        end

        def set_time(time)
          @time = time
        end
	end
end
