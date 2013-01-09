module Abstraxion
  class Cursor < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Cursor
      super(options.merge(:image => Image["cursor.png"]))
      @zorder = 1000
    end
    def update
      @x = $window.mouse_x + 6
      @y = $window.mouse_y + 10
    end
  end
end
