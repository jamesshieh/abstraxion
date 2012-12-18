module Abstraxion
  class MapCellEmpty < GameObject
    def initialize(options = {})
      @zorder = 7
      super(options.merge(:image => Image["mapcellempty.png"]))
    end
  end
  class MapCellHover < GameObject
    def initialize(options = {})
      @zorder = 9
      super(options.merge(:image => Image["mapcellhover.png"]))
    end
    def update
      @x = ($window.mouse_x / $cell_size).to_i * $cell_size + $cell_size / 2.0
      @y = ($window.mouse_y / $cell_size).to_i * $cell_size + $cell_size / 2.0
    end
  end
end
