module Abstraxion
  class Save < Chingu::GameState
    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to save to:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => :exit,
                      :s => :save_state,
                      :l => :load_state,
                      :space => Play
      }
    end

    def save_state
      puts 'Saving state....'
      marshal_dump = Marshal.dump($game)
      file = File.new('saves/save1.sav', 'w')
      file.write(marshal_dump)
      file.close
      puts 'Save Complete'
    end

    def load_state
      puts 'Loading state....'
      file = File.open('saves/save1.sav', 'r')
      $game = Marshal.load(file.read)
      puts $game
      $tower = $game.tower
      puts $tower
      puts $tower.grid
      $generator = $game.generator
      file.close
      puts 'Load Complete'
    end
  end
end

