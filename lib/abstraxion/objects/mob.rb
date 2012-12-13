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
    end

    def destroy
      super
      @hpbar.destroy
    end

    def hp
      @hp
    end

    def hp_bar_remaining
      (@hp/@maxhp * 4.0).to_i
    end

    def hit(damage)
      @hp -= damage
    end

    def alive?
      @hp > 0
    end

    def update
      @x -= 1
    end
  end
end
