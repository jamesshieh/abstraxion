module Abstraxion
  class Pulse < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(pulse, options = {})
      super(options.merge(:image=>Image["pulse.png"]))
      @pulse = pulse
      @zorder = 30
      @target = $window.mouse_y
      @slope = $window.mouse_x
    end

    def damage
      @pulse.amplitude
    end

    def update
      @x += 5
      @y += -(WINDOW_H/2 - @target)/((@slope-125)/5)
    end
  end
end
