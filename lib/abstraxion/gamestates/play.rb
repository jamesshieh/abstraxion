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
      @tower_delay = 60 #always update on first frame or else pulse hash not initialized
      @wave_delay = DELAY_BETWEEN_WAVES
      @wave_counter = @wave_delay
      @spawns = 0
      @level = 1
      self.input = {  :escape => :exit,
                      :m => MapBuild,
                      :p => Pause
      }
    end

    # Reset playing field
    def setup
      @shortest_path ||= shortest_path if $map.generator?

      $tower_cells.each do |cell|
        cell.object.reset
      end unless $tower_cells.empty?
      clear_towers
      Mob.destroy_all
      Pulse.destroy_all

      draw_map
      draw_map_obj

      # Create screen text
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
          Pulse.create(shot, { :x => shot_x, :y => shot_y , :zorder => 12}, [shot_x, shot_y])
        end
      end unless @pulse.empty?
    end

    # Create a wave of 10 monsters
    def wave
      if @wave_counter > DELAY_BETWEEN_MONSTERS
        Mob.create({:x => 975, :y => 325}, @level, @shortest_path.dup)
        @wave_counter = 0
        if @spawns >= MONSTERS_PER_WAVE
          @wave_counter = -(@wave_delay)
          @level += 1
          @spawns = 0
        else
          @spawns += 1
        end
      else
        @wave_counter += 1
      end
    end

    def draw
      super
      draw_pulses
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
      if @tower_delay >= TOWER_UPDATE_INTERVAL
        $generator.update
        $tower_cells.each_with_index  do |cell, i|
          @pulse[i] = cell.object.update
        end unless $tower_cells.empty?
        clear_charges
        $tower_cells.each do |cell|
          draw_charges(cell.object, cell.x, cell.y)
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
