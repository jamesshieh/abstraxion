module Abstraxion
  class HPBar < GameObject
    def initialize(options = {}, object)
      self.zorder = ZOrder::HPBar
      super(options.merge(:image => Image["hpbar4.png"]))
      @object = object
    end
    def update
      @image = Image["hpbar" + @object.hp_bar_remaining.to_s + ".png"]
      @x = @object.x
      @y = @object.y - 30
    end
  end
end
