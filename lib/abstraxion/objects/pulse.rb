module Abstraxion
  class Pulse < GameObject
    def initialize(pulse, options = {})
      @pulse = pulse
      @zorder = 30
      super(options.merge(:image=>Image["pulse.png"]))
    end
    def update
      @x += 5
    end
  end
end
