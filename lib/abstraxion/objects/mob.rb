module Abstraxion
  class Mob < GameObject
    def initialize(options = {})
      @zorder = 40
      super(options.merge(:image => Image["poring.png"]))
    end

    def update
      @x -= 3
    end
  end
end
