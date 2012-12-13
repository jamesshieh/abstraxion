module Abstraxion
  class Build < Master
    def initialize
      super
      @types ||= {:basic => :amplifier, :amplifier => :splitter, :splitter => :switcher, :switcher => :basic}
      self.input = {  :escape => :exit,
                      :space => Play,
                      :left_mouse_button => :toggle_connection,
                      :right_mouse_button => :edit_node_type
      }
    end

    def setup
      scale = 1
      $node_size = NODE_SIZE.to_int * scale
      $size = FACTOR * scale
      super
    end

    def find_mouse_quadrant
      m_x, m_y = $window.mouse_x, $window.mouse_y
      x_offset = m_x % $node_size
      y_offset = (m_y -(WINDOW_H / 2 - 0.5 * $tower.y * $node_size)) % $node_size
      if y_offset > x_offset
        ($node_size - y_offset) > x_offset ? :W : :S
      else
        ($node_size - y_offset) > x_offset ? :N : :E
      end
    end

    def toggle_connection
      m_x, m_y = $window.mouse_x, $window.mouse_y
      x = (m_x/$node_size).to_int
      y = (m_y -(WINDOW_H / 2 - 0.5 * $tower.y * $node_size)).to_int/$node_size
      direction = find_mouse_quadrant
      return unless x.between?(0, $tower.x-1) && y.between?(0, $tower.y-1)
      if $tower.grid.connected?(x, y, direction)
        $tower.grid.remove_connection(x, y, direction)
      else
        $tower.grid.create_connection(x, y, direction)
      end
      draw_tower
    end

    def edit_node_type
      m_x, m_y = $window.mouse_x, $window.mouse_y
      x = m_x/$node_size
      y = (m_y -(WINDOW_H / 2 - 0.5 * $tower.y * $node_size))/$node_size
      if (x > 0 || y > 0) && (x < $tower.x && y < $tower.y)
        $tower.grid.set_type(x, y, @types[$tower.grid.get_type(x,y)])
      end
      draw_tower
    end

    def draw_mouse_hover_connection
      HoverConnector.destroy_all
      m_x, m_y = $window.mouse_x, $window.mouse_y
      x = (m_x/$node_size).to_int
      y = (m_y -(WINDOW_H / 2 - 0.5 * $tower.y * $node_size)).to_int/$node_size
      if x.between?(0,$tower.x-1) && y.between?(0,$tower.y-1)
        direction = find_mouse_quadrant
        draw_x = x*$node_size + $node_size/2
        draw_y = WINDOW_H / 2 - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
        @angle ||= {:N => 0,:S => 180, :E => 90, :W => 270}
        HoverConnector.create(:x => draw_x, :y => draw_y, :angle => @angle[direction], :factor_x => $size, :factor_y => $size)
      end
    end

    def update
      draw_mouse_hover_connection
      $cursor.update
      $window.caption = "Edit Mode. FPS #{$window.fps}"
    end
  end
end
