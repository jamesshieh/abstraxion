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

  class MapCellPreviewGen < GameObject
    def initialize(options = {})
      @zorder = 8
      super(options.merge(:image => Image["mapcellgen.png"]))
    end
  end

  class MapCellGen < GameObject
    trait :bounding_box
    traits :collision_detection

    include HPBarHelper
    include ObjectHelper

    def initialize(options = {})
      @hpbar = HPBar.create({}, self)
      @zorder = 8
      @hp, @maxhp = $generator.status
      super(options.merge(:image => Image["mapcellgen.png"]))
    end

    def hit(damage = 10)
      $generator.hit(damage)
    end

    def destroy
      super
      @hpbar.destroy
    end

    def update
      @hp, @maxhp = $generator.status
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
