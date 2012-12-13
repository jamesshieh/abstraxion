module Abstraxion
  class Pulse < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(pulse, options = {})
      super(options.merge(:image=>Image["pulse.png"]))
      @pulse = pulse
      @zorder = 30
    end

    def damage
      @pulse.amplitude
    end

    def update
      @x += 5
      @y < $window.mouse_y ? @y += 2 : @y -= 2
    end
  end
end
