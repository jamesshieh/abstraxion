module Enemy
  # Monster class
  class Mob
    attr_reader :hp, :name
    def initialize(name, hp, damage)
      @name = name
      @hp = hp
      @damage = damage
      @evasion = 0.05
    end

    def alive?
      @hp > 0
    end

    def take_hit(damage)
      if rand > @evasion
        @hp -= damage
        :hit
      else
        :miss
      end
    end
  end
end
