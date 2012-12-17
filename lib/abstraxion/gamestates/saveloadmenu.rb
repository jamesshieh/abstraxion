module Abstraxion
  # Save and load superclass
  class SaveLoadMenu < Chingu::GameState

    include GameStateHelper

    def initialize
      super
      @saved_towers = {:save1 => nil, :save2 => nil, :save3 => nil}
      scale = 0.25
      @size = FACTOR * scale
      $node_size = NODE_SIZE * scale
    end

    def setup
      super
      clear_towers
      load_previews
      @savedt1, @savedt2, @savedt3 = @saved_towers.values
      draw_cursor
      @save1 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 2 * WINDOW_H/7)
      draw_tower(@savedt1, 255, 2 * WINDOW_H/7, @size) unless @savedt1.nil?
      @save2 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 4 * WINDOW_H/7)
      draw_tower(@savedt2, 255, 4 * WINDOW_H/7, @size) unless @savedt2.nil?
      @save3 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 6 * WINDOW_H/7)
      draw_tower(@savedt3, 255, 6 * WINDOW_H/7, @size) unless @savedt3.nil?
    end

    # Saves state based on mouse hover position
    def save_state
      savefile = ''
      if @save1.mouse_hover?
        savefile = 'save1'
      elsif @save2.mouse_hover?
        savefile = 'save2'
      elsif @save3.mouse_hover?
        savefile = 'save3'
      end

      unless savefile.nil?
        puts "Saving state to #{savefile}...."
        marshal_dump = Marshal.dump($game)
        file = File.new('saves/' + savefile + '.sav', 'w')
        file.write(marshal_dump)
        file.close
        puts "Save Complete"
      end
      self.setup
    end

    # Load states for preview
    def load_previews
      files = ['save1', 'save2', 'save3']
      files.each do |save|
        begin
          file = File.open('saves/' + save + '.sav', 'r')
          state = Marshal.load(file.read)
          @saved_towers[save.to_sym] = state.tower
          puts "Loaded preview for #{save}."
          file.close
        rescue Errno::ENOENT
          puts "Unable to load preview for #{save}."
          @saved_towers[save.to_sym] = nil
        end
      end
    end

    # Loads state based on mouse hover position
    def load_state
      savefile = ''
      if @save1.mouse_hover?
        savefile = 'save1'
      elsif @save2.mouse_hover?
        savefile = 'save2'
      elsif @save3.mouse_hover?
        savefile = 'save3'
      end

      unless savefile.nil?
        puts "Loading state from #{savefile}...."
        begin
          file = File.open('saves/' + savefile + '.sav', 'r')
          $game = Marshal.load(file.read)
          $tower = $game.tower
          $generator = $game.generator
          file.close
          puts 'Load Complete'
        rescue Errno::ENOENT
          puts "Unable to load save file"
        end
      end
    end

    # Draw the 3 save boxes
    def draw
      super
    end
  end
end

