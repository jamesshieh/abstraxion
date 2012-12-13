module Abstraxion
  class HPBar < GameObject
    def initialize(options = {}, monster)
      super(options.merge(:image => Image["hpbar4.png"]))
      @monster = monster
    end
    def update
      @image = Image["hpbar" + @monster.hp_bar_remaining.to_s + ".png"]
      @x = @monster.x
      @y = @monster.y - 30
    end
  end
end
