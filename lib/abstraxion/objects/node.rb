module Abstraxion
  class Charge < GameObject
    def initialize(options = {}, pulse)
      self.zorder = ZOrder::Charge
      super(options.merge(:image => Image["charge.png"]))
      @pulse = pulse
      @move_direction ||= @pulse.direction
      case @move_direction
      when :N
        @y = @y + 10
      when :S
        @y = @y - 10
      when :E
        @x = @x - 10
      when :W
        @x = @x + 10
      end
    end

    def update
      super
      case @move_direction
      when :N
        @y -= 1
      when :S
        @y += 1
      when :E
        @x += 1
      when :W
        @x -= 1
      end
    end
  end

  class Node < GameObject
    def initialize(options = {}, type)
      self.zorder = ZOrder::Node
      super(options.merge(:image => Image[type.to_s + ".png"]))
    end
  end
end
