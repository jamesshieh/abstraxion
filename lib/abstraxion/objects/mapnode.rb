module Abstraxion
  class MapCellEmpty < GameObject

    include ObjectHelper

    def initialize(options = {})
      self.zorder = ZOrder::Grid
      super(options.merge(:image => Image["mapcellempty.png"]))
    end
  end

  class MapCellHover < GameObject

    include ObjectHelper

    def initialize(options = {})
      self.zorder = ZOrder::Hover
      super(options.merge(:image => Image["mapcellhover.png"]))
    end
  end

  class MapCellPreviewGen < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Generator
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
      self.zorder = ZOrder::Generator
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
      self.zorder = ZOrder::Wall
      super(options.merge(:image => Image["mapcellwall.png"]))
    end
  end

  class EditSelection < GameObject

    include ObjectHelper

    def initialize(options = {})
      self.zorder = ZOrder::Hover
      super(options.merge(:image => Image["editselection.png"]))
    end
  end
end
