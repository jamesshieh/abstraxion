module Abstraxion
  class MapBuild < Master

    def initialize
      scale = 0.10
      $node_size = NODE_SIZE * scale
      @cell_size = $node_size * 5
      @size = FACTOR * scale
      super
      @selection ||= nil

      @sidebar_controls1 = Chingu::Text.create(:text => "Right click to select a tower", :x => 1000, :y => 10, :size => 15)
      @sidebar_controls2 = Chingu::Text.create(:text => "Left click to place", :x => 1000, :y => 25, :size => 15)
      @sidebar_controls3 = Chingu::Text.create(:text => "\"Delete\" to remove", :x => 1000, :y => 40, :size => 15)
      @sidebar_controls4 = Chingu::Text.create(:text => "Click GEN then a tower to power", :x => 1000, :y => 55, :size => 15)
      @sidebar_label_tower1 = Chingu::Text.create(:text => "Tower 1", :x => 1050, :y => 80, :size => 15)
      @sidebar_label_tower2 = Chingu::Text.create(:text => "Tower 2", :x => 1050, :y => 180, :size => 15)
      @sidebar_label_tower3 = Chingu::Text.create(:text => "Tower 3", :x => 1050, :y => 280, :size => 15)
      @sidebar_label_gen = Chingu::Text.create(:text => "Generator(req)", :x => 1040, :y => 380, :size => 15)
      @sidebar_label_wall = Chingu::Text.create(:text => "Wall", :x => 1055, :y => 480, :size => 15)
      @controls = Chingu::Text.create(:text => "Press 't' to edit currently selected tower, 'm or esc' to resume play, 'p' to pause.", :x => 100, :y => 635, :size => 30)
      self.input = {  :escape => Play,
                      :m => Play,
                      :t => TowerEdit,
                      :p => Pause,
                      :left_mouse_button => :mouse_event,
                      :right_mouse_button => :edit_select,
                      :delete => :delete_object
      }
    end

    def setup
      clear_towers
      draw_map
      draw_map_obj
      draw_sidebar
      @cell = MapCellHover.create(:x => 0, :y => 0)
      super
    end

    def mouse_event
      if $map.get_type(@grid_x, @grid_y).nil?
        build_object
      elsif $map.get_type(@grid_x, @grid_y) == MapAbxn::Generator
        push_game_state(GeneratorConnectionPhase)
      end if @grid_x.between?(0, $map.x-1) && @grid_y.between?(0, $map.y-1)
    end

    def build_object
      if @selection.class == MapAbxn::Tower
        tower = Marshal.load(Marshal.dump(@selection))
        cell = $map.create_object(@grid_x, @grid_y, tower)
        $game.add_tower(cell)
      else
        $map.create_object(@grid_x, @grid_y, @selection)
      end unless @selection.nil?
      draw_map_obj
      draw_sidebar
    end

    def delete_object
      $map.delete_object(@grid_x, @grid_y) unless $map.get_type(@grid_x, @grid_y).nil?
      draw_map_obj
      draw_sidebar
    end

    def edit_select
      if @mouse_x.between?(1050, 1100)
        if @mouse_y.between?(100, 150)
          $tower = $tower1
          @selection = $tower
          EditSelection.destroy_all
          EditSelection.create(:x => 1075, :y => 125)
        elsif @mouse_y.between?(200, 250)
          $tower = $tower2
          @selection = $tower
          EditSelection.destroy_all
          EditSelection.create(:x => 1075, :y => 225)
        elsif @mouse_y.between?(300, 350)
          $tower = $tower3
          @selection = $tower
          EditSelection.destroy_all
          EditSelection.create(:x => 1075, :y => 325)
        elsif @mouse_y.between?(400, 450)
          @selection = MapAbxn::Wall.new
          EditSelection.destroy_all
          EditSelection.create(:x => 1075, :y => 425)
        elsif @mouse_y.between?(500, 550)
          @selection = $generator
          EditSelection.destroy_all
          EditSelection.create(:x => 1075, :y => 525)
        end
      end
    end

    def draw_sidebar
      draw_tower($tower1, 1050, 100, @size)
      draw_tower($tower2, 1050, 200, @size)
      draw_tower($tower3, 1050, 300, @size)
      MapCellWall.create(:x => 1075, :y => 425)
      MapCellPreviewGen.create(:x => 1075, :y => 525)
    end

    def draw
      @cell.move_to(@mouse_x, @mouse_y)
      super
    end

    def update
      @mouse_x = ($window.mouse_x / @cell_size).to_i * @cell_size + @cell_size / 2.0
      @mouse_y = ($window.mouse_y / @cell_size).to_i * @cell_size + @cell_size / 2.0
      @grid_x = @mouse_x.to_int/50
      @grid_y = @mouse_y.to_int/50
      super
      $window.caption = "Map Build Mode, FPS: #{$window.fps}"
    end
  end
end

