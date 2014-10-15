module Title
	class Director
		def initialize
			@bg_img = Image.load("images/ginzan.png")
			@shimanekko = Image.load("images/shimanekko.png")
            @bg_img.draw_font(500, 100, "しまねっこをクリック", Font.new(32))
		end
			
		def play
			Window.draw(0, 0, @bg_img)

			Window.draw(400, 400, @shimanekko)
            if Input.mouse_push?(M_LBUTTON)
              mouse_x = Input.mouse_pos_x
              mouse_y = Input.mouse_pos_y

              if range_ok?(@shimanekko, 400, 400, mouse_x, mouse_y)
                Scene.get_scene(:game).state.start_time = Time.now.to_i
                Scene.set_current_scene(:game)
              end
            end
		end

        def range_ok?(image, x0, y0, x, y)
          return false unless x0 < x
          return false unless x < x0 + image.width 
          return false unless y0 < y
          return false unless y < y0 + image.height

          return true
        end
	end
end
