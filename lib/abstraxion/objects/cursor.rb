module Abstraxion
  class Cursor < GameObject
    def initialize(options = {})
      super(options.merge(:image => Image["cursor.png"]))
      self.zorder = ZOrder::Cursor
      @zorder = 1000
    end
    def update
      @x = $window.mouse_x + 6
      @y = $window.mouse_y + 10
    end
  end
end
