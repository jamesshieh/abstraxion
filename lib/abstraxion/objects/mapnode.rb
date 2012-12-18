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
  end
end
