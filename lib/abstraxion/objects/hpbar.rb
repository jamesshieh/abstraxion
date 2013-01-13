module Abstraxion
  class HPBar < GameObject
    def initialize(options = {}, object)
      super(options.merge(:image => Image["hpbar4.png"]))
      self.zorder = ZOrder::HPBar
      @object = object
    end
    def update
      $hp_flag ? @image = Image["hpbar" + @object.hp_bar_remaining.to_s + ".png"] : @image = Image["invisible.png"]
      @x = @object.x
      @y = @object.y - 30
    end
  end
end
