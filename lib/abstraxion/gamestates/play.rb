module Abstraxion
  class Play < Master

    def initialize
      @pulse = {}
      @current_dps = 0
      @dps = []
      scale = 0.10
      $node_size = NODE_SIZE * scale
      @size = FACTOR * scale
      @cell_size = $node_size * 5
      super
      @tower_delay = 10
      @wave_delay = 60
      @level = 1
      self.input = {  :escape => :exit,
                      :m => MapBuild,
                      :p => Pause
      }
    end

    # Reset playing field
    def setup
      @shortest_path ||= shortest_path if $map.generator?
      clear_towers
      draw_map
      draw_map_obj
      $tower_cells.each do |cell|
        cell.object.reset
      end unless $tower_cells.empty?
      Mob.destroy_all
      Pulse.destroy_all
      @controls = Chingu::Text.create(:text => "Press 'm' for building mode, 'p' to pause", :x => 100, :y => 615, :size => 30)
      @status = Chingu::Text.create(:text => "Gen Level: #{$generator.level}, Gen HP: #{$generator.hp}, Exp to Next: #{$generator.exp_left}, Connections Avail: #{$generator.connections.length}", :x => 100, :y => 666, :size => 20)
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
          shot_x = @cell_size * cell.x
          shot_y = @cell_size * cell.y
          Pulse.create(shot, { :x => shot_x, :y => shot_y }, [shot_x, shot_y])
        end
      end
    end

    def wave
      if @wave_delay > 60
        Mob.create({:x => 975, :y => 325}, @level, @shortest_path.dup)
        @wave_delay = 0
        @level += 1 if rand(0..2)
      else
        @wave_delay += 1
      end
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
      wave if $map.generator?
      super
      Mob.each_collision(Pulse) { |mob, pulse|
        mob.hit(pulse.damage)
        pulse.destroy
      }
      Mob.each_collision(MapCellGen) { |mob, gen|
        gen.hit(mob.hp)
        mob.destroy
      }
      Pulse.select { |obj| obj.outside_window? }.each(&:destroy)
      Mob.each do |mob|
        if !mob.alive?
          $generator.gain_exp(mob.level)
          mob.destroy
        end
      end
      if @tower_delay >= 10
        $generator.update
        $tower_cells.each_with_index do |cell, i|
          @pulse[i] = cell.object.update
        end unless $tower_cells.empty?
        @tower_delay = 0
      else
        @tower_delay += 1
      end
      push_game_state(GameOver) unless $generator.alive?
      #!@pulse.values.empty? ? dps(@pulse.values.inject(:+)) : dps(0) # TODO:
      #Fix the pulse values to return number instead of object
      @status.text = "Gen Level: #{$generator.level}, Gen HP: #{$generator.hp}, Exp to Next: #{$generator.exp_left}, Connections Avail: #{$generator.connections.length}"
      $window.caption = "Play Mode, FPS: #{$window.fps}"
    end
  end
end
