module Abstraxion

  class Pulse < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(pulse, options = {}, origin)
      super(options.merge(:image=>Image["pulse.png"]))
      @origin_x, @origin_y = origin
      @pulse = pulse
      @zorder = 30
      @target_x = $window.mouse_x
      @target_y = $window.mouse_y
      @slope = (@origin_y - @target_y)/(@target_x - @origin_x)
      @angle = Math.atan(@slope)
    end

    def damage
      @pulse.amplitude
    end

    def update
      @target_x < @origin_x ? @x -= Math.cos(@angle) * 5 : @x += Math.cos(@angle) * 5
      @target_x < @origin_x ? @y += Math.sin(@angle) * 5 : @y -= Math.sin(@angle) * 5
    end
  end

  class Splash < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(options = {})
    end
  end

end
