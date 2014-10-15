class ImageFilter
  def self.circle(image, x0, y0, r, color = [0,0,0])
    # image.fill(color)
    image.circle_fill(x0, y0, r, [0,0,0,0])

    image
  end

  def self.box(image, x0, y0, x1, y1, color = [0,0,0])
    # image.fill(color)
    image.box_fill(x0, y0, x1, y1, [0,0,0,0])

    image
  end
end

