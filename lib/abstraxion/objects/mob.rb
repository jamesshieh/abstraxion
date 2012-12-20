module Abstraxion
  class Mob < GameObject
    trait :bounding_circle
    traits :collision_detection

    attr_reader :level

    include HPBarHelper

    def initialize(options = {}, level = 1, path = [:W,:N,:W,:S,:E,:W,:N,:N,:W,:W,:W,:W,:W,:W,:W,:W,:W,:W,:W,:W])
      self.zorder = ZOrder::Monster
      @path = path
      @level = level
      @hp = 1 + @level
      @maxhp = @hp
      @velocity = 1
      @walk ||= walk
      @hpbar = HPBar.create({}, self)
      super(options.merge(:image => Image["poring.png"]))
      cache_bounding_circle
    end

    def destroy
      super
      @hpbar.destroy
    end

    def hit(damage)
      @hp -= damage
    end

    def alive?
      @hp > 0
    end

    def walk
      Fiber.new do
        @path.nil? ? direction = :W : direction = @path.pop
        steps = 50/@velocity
        loop do
          if steps > 0
            case direction
            when :N
              @y -= @velocity
              Fiber.yield
            when :S
              @y += @velocity
              Fiber.yield
            when :E
              @x += @velocity
              Fiber.yield
            when :W
              @x -= @velocity
              Fiber.yield
            end
            steps -= 1
          else
            @path.nil? ? direction = :W : direction = @path.pop
            steps = 50/@velocity
          end
        end
      end
    end

    def update
      @walk.resume
    end
  end
end
