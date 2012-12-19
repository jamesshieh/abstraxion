module Abstraxion
  class MapCellEmpty < GameObject

    include ObjectHelper

    def initialize(options = {})
      @zorder = 7
      super(options.merge(:image => Image["mapcellempty.png"]))
    end
  end

  class MapCellHover < GameObject

    include ObjectHelper

    def initialize(options = {})
      @zorder = 9
      super(options.merge(:image => Image["mapcellhover.png"]))
    end
  end

  class MapCellGen < GameObject

    include ObjectHelper

    def initialize(options = {})
      @zorder = 8
      super(options.merge(:image => Image["mapcellgen.png"]))
    end
  end

  class MapCellWall < GameObject

    include ObjectHelper

    def initialize(options = {})
      @zorder = 8
      super(options.merge(:image => Image["mapcellwall.png"]))
    end
  end

  class EditSelection < GameObject

    include ObjectHelper

    def initialize(options = {})
      @zorder = 9
      super(options.merge(:image => Image["editselection.png"]))
    end
  end
end
