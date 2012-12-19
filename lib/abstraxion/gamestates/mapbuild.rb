module Abstraxion
  class MapBuild < Master

    def initialize
      super
      self.input = {  :escape => Play,
                      :m => Play,
                      :left_mouse_button => :build_object,
                      :right_mouse_button => :edit_select
      }
      @mouse_x = 0
      @mouse_y = 0
      @selection = nil
    end

    def setup
      clear_towers
      draw_map
      draw_map_obj
      draw_sidebar
      @cell = MapCellHover.create(:x => 0, :y => 0)
      super
    end

    def build_object
      tower = Marshal.load(Marshal.dump(@selection))
      cell = $map.create_object(@grid_x, @grid_y, tower)
      $game.add_tower(cell) if cell.object.class == MapAbxn::Tower
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
      draw_tower($tower1, 1050, 100, 0.1)
      draw_tower($tower2, 1050, 200, 0.1)
      draw_tower($tower3, 1050, 300, 0.1)
      MapCellWall.create(:x => 1075, :y => 425)
      MapCellGen.create(:x => 1075, :y => 525)
    end

    def draw
      @cell.move_to(@mouse_x, @mouse_y)
      super
    end

    def update
      @mouse_x = ($window.mouse_x / $cell_size).to_i * $cell_size + $cell_size / 2.0
      @mouse_y = ($window.mouse_y / $cell_size).to_i * $cell_size + $cell_size / 2.0
      @grid_x = @mouse_x.to_int/50
      @grid_y = @mouse_y.to_int/50
      super
    end
  end
end

