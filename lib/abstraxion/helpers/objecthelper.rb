module ObjectHelper
  def mouse_hover?
    w, h = self.size
    return $window.mouse_x.between?(self.x - w/2, self.x + w/2) && $window.mouse_y.between?(self.y - h/2, self.y + h/2)
  end
  def move_to(x, y)
    @x = x
    @y = y
  end
end
