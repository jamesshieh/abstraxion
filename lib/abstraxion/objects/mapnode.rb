module Abstraxion
  class MapCellEmpty < GameObject

    include ObjectHelper

    def initialize(options = {})
      super(options.merge(:image => Image["mapcellempty.png"]))
      self.zorder = ZOrder::Grid
    end
  end

  class MapCellHover < GameObject

    include ObjectHelper

    def initialize(options = {})
      super(options.merge(:image => Image["mapcellhover.png"]))
      self.zorder = ZOrder::Hover
    end
  end

  class MapCellPreviewGen < GameObject
    def initialize(options = {})
      super(options.merge(:image => Image["mapcellgen.png"]))
      self.zorder = ZOrder::Generator
    end
  end

  class MapCellGen < GameObject
    trait :bounding_box
    traits :collision_detection

    include HPBarHelper
    include ObjectHelper

    def initialize(options = {})
      @hpbar = HPBar.create({}, self)
      @hp, @maxhp = $generator.status
      super(options.merge(:image => Image["mapcellgen.png"]))
      self.zorder = ZOrder::Generator
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
      super(options.merge(:image => Image["mapcellwall.png"]))
      self.zorder = ZOrder::Wall
    end
  end

  class EditSelection < GameObject

    include ObjectHelper

    def initialize(options = {})
      super(options.merge(:image => Image["editselection.png"]))
      self.zorder = ZOrder::Hover
    end
  end
end
