module Abstraxion
  class Mob < GameObject
    trait :bounding_circle
    traits :collision_detection
    def initialize(options = {})
      @zorder = 40
      @hp = 10.0
      @maxhp = @hp
      @hpbar = HPBar.create({}, self)
      super(options.merge(:image => Image["poring.png"]))
      cache_bounding_circle
    end

    def destroy
      super
      @hpbar.destroy
    end

    def hp
      @hp
    end

    def hp_bar_remaining
      val = (@hp/@maxhp * 4.0).to_i
      val.between?(0, 4) ? val : 0
    end

    def hit(damage)
      @hp -= damage
    end

    def alive?
      @hp > 0
    end

    def update
      destroy unless alive?
      @x -= 1
    end
  end
end
