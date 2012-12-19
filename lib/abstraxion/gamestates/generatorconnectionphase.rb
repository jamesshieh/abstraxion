module Abstraxion
  class GeneratorConnectionPhase < Master
    def initialize
      super
      self.input = {  :escape => MapBuild,
                      :p => Pause,
                      :left_mouse_button => :toggle_connection
      }
      scale = 0.1
      $node_size = NODE_SIZE * scale
      @cell_size = $node_size * 5
      @size = FACTOR * scale
      @color = Gosu::Color.new(50,255,255,255)
    end

    def toggle_connection
      if $map.get_type(@grid_x, @grid_y) == MapAbxn::Tower
        $generator.connect_tower($map.get_cell(@grid_x, @grid_y).object, $generator.default_connection)
        push_game_state(MapBuild)
      end
    end

    def setup
      super
    end

    def draw
      previous_game_state.draw
      $window.draw_quad(0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER)
      super
    end

    def update
      @mouse_x = ($window.mouse_x / @cell_size).to_i * @cell_size + @cell_size / 2.0
      @mouse_y = ($window.mouse_y / @cell_size).to_i * @cell_size + @cell_size / 2.0
      @grid_x = @mouse_x.to_int/50
      @grid_y = @mouse_y.to_int/50
      super
      $window.caption = "Generator Connection Mode, FPS: #{$window.fps}"
    end
  end
end
