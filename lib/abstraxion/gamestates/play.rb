module Abstraxion
  class Play < Master
    def initialize
      @pulse = []
      @level = 1
      @current_dps = 0
      @dps = []
      scale = 0.10
      @size = FACTOR * scale
      $node_size = NODE_SIZE * scale
      $cell_size = $node_size * 5
      super
      self.input = {  :escape => :exit,
                      :space => TowerEdit,
                      :m => MapBuild
      }
    end

    # Reset playing field
    def setup
      draw_map
      $tower.reset
      Mob.destroy_all
      Pulse.destroy_all
      super
    end

    # Calculates the DPS of the tower by taking the last 10 seconds of shots
    def dps(damage)
      @dps << damage
      @dps.shift if @dps.size > 60
      @current_dps = @dps.inject(0.0) { |sum, el| sum + el }
    end

    # Creates shots out of the tower when a pulse returns
    def draw_pulses
      if !@pulse.empty?
        shot = @pulse.pop
        origin = [50, 50]
        Pulse.create(shot,{ :x => $node_size * $tower.x, :y => $node_size * $tower.y } , origin)
      end
    end

    def wave
    end

    def draw
      draw_charges
      draw_pulses
      super
    end

    # Steps through towers and deterines speed of updates, spawns monsters
    def update
      super
      Pulse.select { |obj| obj.outside_window? }.each(&:destroy)
      $generator.update
      @pulse = $tower.update
      !@pulse.empty? ? dps(@pulse[0].amplitude) : dps(0)
      $window.caption = "FPS: #{$window.fps}, DPS: #{@current_dps.round(3)}"
    end
  end
end
