module SaveLoadHelper

  # Saves state based on mouse hover position
  def save_state
    savefile = nil
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
    files.each do |savefile|
      begin
        file = File.open('saves/' + savefile + '.sav', 'r')
        state = Marshal.load(file.read)
        @saved_towers[savefile.to_sym] = state.tower1
        puts "Loaded preview for #{savefile}."
        file.close
      rescue Errno::ENOENT
        puts "Unable to load preview for #{savefile}."
        @saved_towers[savefile.to_sym] = nil
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
        $tower_cells = $game.tower_cells
        $generator = $game.generator
        $map = $game.map
        $tower1 = $game.tower1
        $tower2 = $game.tower2
        $tower3 = $game.tower3
        $tower4 = $game.tower4
        $tower5 = $game.tower5
        $tower = $tower1
        $wall = $game.wall

        file.close
        puts 'Load Complete'
      rescue Errno::ENOENT
        puts "Unable to load save file"
      end
    end
  end
end
