module Abstraxion

  class Pulse < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(pulse, options = {}, origin)
      super(options.merge(:image=>Image["pulse.png"]))
      @pulse = pulse
      @zorder = 30
      @slope = (origin[0] - $window.mouse_y)/($window.mouse_x - origin[1])
      @angle = Math.atan(@slope)
    end

    def damage
      @pulse.amplitude
    end

    def update
      @x += Math.cos(@angle) * 10
      @y += - Math.sin(@angle) * 10
    end
  end

  class Splash < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(options = {})
    end
  end

end
