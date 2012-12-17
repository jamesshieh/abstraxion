module Abstraxion
  class Play < Master
    def initialize
      @pulse = []
      @level = 1
      @current_dps = 0
      @dps = []
      scale = 0.25
      @size = FACTOR * scale
      $node_size = NODE_SIZE * scale
      super
      self.input = {  :escape => :exit,
                      :space => Build
      }
    end

    def setup
      super
      Mob.destroy_all
      Pulse.destroy_all
      $tower.reset
      draw_tower
    end

    # Iterate through grid and draw charges where they exist
    def draw_charges
      Charge.destroy_all
      $tower.grid.grid_iterator.each_with_index do |node, i|
        draw_charge(i % $tower.y, i / $tower.y) if !node.pulses.empty?
      end
    end

    # Draws a charge in a specific node
    def draw_charge(x, y)
      draw_x = x*$node_size + $node_size/2
      draw_y = WINDOW_H / 2 - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
      Charge.create(:x => draw_x, :y => draw_y, :factor_x => @size, :factor_y => @size)
    end

    # Calculates the DPS of the tower by taking the last 10 seconds of shots
    def dps(damage)
      @dps << damage
      @dps.shift if @dps.size > 60
      @current_dps = @dps.inject(0.0) { |sum, el| sum + el } / (@dps.size)
    end
  
    # Creates shots out of the tower when a pulse returns
    def draw_pulses
      if !@pulse.empty?
        shot = @pulse.pop
        puts "Pulse fired causing #{shot.amplitude} points of damage!"
        Pulse.create(shot, :x => $node_size * $tower.x, :y => WINDOW_H / 2)
      end
    end

    def draw
      super
      draw_charges
      draw_pulses
      Mob.create(:x => 1280, :y => rand(300..400)) if rand(0..1000) <= @level
    end

    # Steps through towers and deterines speed of updates, spawns monsters
    def update
      super
      game_objects.select { |obj| obj.outside_window? }.each(&:destroy)
      $generator.update
      @pulse = $tower.update
      !@pulse.empty? ? dps(@pulse[0].amplitude) : dps(0)
      Mob.each do |monster|
        monster.each_collision(Pulse) do |mob, pulse|
          mob.hit(pulse.damage)
          pulse.destroy
        end
      end
      $cursor.update
      $window.caption = "FPS: #{$window.fps}, DPS: #{@current_dps.round(3)}"
    end
  end
end
