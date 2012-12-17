module Abstraxion
  # Save and load superclass
  class SaveLoadMenu < Chingu::GameState

    include GameStateHelper

    def initialize
      super
    end

    def setup
      super
      draw_cursor
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
        file = File.open('saves/' + savefile + '.sav', 'r')
        $game = Marshal.load(file.read)
        $tower = $game.tower
        $generator = $game.generator
        file.close
        puts 'Load Complete'
      end
    end

    # Draw the 3 save boxes
    def draw
      super
      @save1 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 2 * WINDOW_H/7 )
      @save2 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 4 * WINDOW_H/7)
      @save3 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 6 * WINDOW_H/7)
    end
  end
end

