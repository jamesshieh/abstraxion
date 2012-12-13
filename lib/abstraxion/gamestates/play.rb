module Abstraxion
  class Play < Master
    def initialize
      @pulse = []
      @level = 1
      @current_dps = 0
      @dps = []
      @mobs = []
      super
      self.input = {  :escape => :exit,
                      :space => Build
      }
    end

    def setup
      super
      scale = 0.25
      $size = FACTOR * scale
      $node_size = NODE_SIZE * scale

      $tower.reset
      draw_tower
    end

    def dps(damage)
      @dps << damage
      @dps.shift if @dps.size > 60
      @current_dps = @dps.inject(0.0) { |sum, el| sum + el } / (@dps.size/6)
    end
  
    def draw_pulses
      if !@pulse.empty?
        shot = @pulse.pop
        puts "Pulse fired causing #{shot.amplitude} points of damage!"
        Pulse.create(shot, :x => $node_size * $tower.x, :y => WINDOW_H / 2)
      end
    end

    def update
      super
      if $delay == 10
        $generator.update
        @pulse = $tower.update
        if !@pulse.empty?
          dps(@pulse[0].amplitude)
        else
          dps(0)
        end
        draw_charges
        draw_pulses
        $delay = 0
      else
        $delay += 1
      end
      @mobs << Mob.create(:x => 1280, :y => rand(300..400)) if rand(0..1000) <= @level
      @mobs.each do |monster|
        monster.each_collision(Pulse) do |mob, pulse|
          mob.hit(pulse.damage)
          pulse.destroy
          if !mob.alive?
            mob.destroy 
            @level += 1
          end
        end
      end
      $cursor.update
      $window.caption = "FPS: #{$window.fps}, DPS: #{@current_dps.round(3)}"
    end
  end
end
