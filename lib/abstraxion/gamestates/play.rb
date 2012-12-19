module Abstraxion
  class Play < Master

    def initialize
      @pulse = {}
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
      clear_towers
      draw_map
      draw_map_obj
      $tower_cells.each do |cell|
        cell.object.reset
      end unless $tower_cells.empty?
      Mob.destroy_all
      Pulse.destroy_all
      super
    end

    # Calculates the DPS of the tower by taking the last 10 seconds of shots
    # TODO: FIX THE DPS COUNTER RIGHT NOW IT IS GETTING OBJECTS INSTEAD OF
    # AMPLITUDES
    def dps(damage)
      @dps << damage
      @dps.shift if @dps.size > 60
      @current_dps = @dps.inject(:+)
    end

    # Creates shots out of the tower when a pulse returns
    def draw_pulses
      $tower_cells.each_with_index do |cell, i|
        if !@pulse[i].empty?
          shot = @pulse[i].pop
          shot_x = $cell_size * cell.x
          shot_y = $cell_size * cell.y
          Pulse.create(shot, { :x => shot_x, :y => shot_y }, [shot_x, shot_y])
        end
      end
    end

    def wave
    end

    def draw
      clear_charges
      $tower_cells.each do |cell|
        draw_charges(cell.object, cell.x, cell.y)
      end unless $tower_cells.empty?
      draw_pulses
      super
    end

    # Steps through towers and deterines speed of updates, spawns monsters
    def update
      super
      Pulse.select { |obj| obj.outside_window? }.each(&:destroy)
      $generator.update
      $tower_cells.each_with_index do |cell, i|
        @pulse[i] = cell.object.update
      end unless $tower_cells.empty?
      #!@pulse.values.empty? ? dps(@pulse.values.inject(:+)) : dps(0) # TODO:
      #Fix the pulse values to return number instead of object
      $window.caption = "FPS: #{$window.fps}"
    end
  end
end
