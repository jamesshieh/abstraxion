module Abstraxion
  # Building game state where the tower grid can be edited
  class TowerEdit < Master
    def initialize
      super
      @types ||= {:basic => :amplifier, :amplifier => :splitter, :splitter => :switcher, :switcher => :basic}
      self.input = {  :t => MapBuild,
                      :esc => MapBuild,
                      :p => Pause,
                      :left_mouse_button => :toggle_connection,
                      :right_mouse_button => :edit_node_type
      }
      @black = Color.rgb(0,0,0)
      @tower_x = 0
      @tower_y = 0
      scale = 1
      $node_size = NODE_SIZE.to_int * scale
      @size = FACTOR * scale
      @cost = $tower.cost
      @controls1 = Chingu::Text.create(:text => "Press 't' or 'esc' to return to build mode", :x => 100, :y => 620, :size => 30)
      @controls2 = Chingu::Text.create(:text => "Left click to toggle a connection on or off, right click to change node type", :x => 100, :y => 655, :size => 20)
      @cost_display = Chingu::Text.create(:text => "Current tower cost: #{@cost}", :x => 600, :y => 500, :size => 50)
      @tower_nodes1 = Chingu::Text.create(:text => "Node Types:", :x => 600, :y => 50, :size => 20, :color => @black)
      @tower_nodes2 = Chingu::Text.create(:text => "AM - Amplifies a pulse 20%", :x => 600, :y => 100, :size => 20,:color => @black)
      @tower_nodes3 = Chingu::Text.create(:text => "SW - Switches between outputs", :x => 600, :y => 150, :size => 20,:color => @black)
      @tower_nodes4 = Chingu::Text.create(:text => "SP - Reduces overall power by 10% and", :x => 600, :y => 200, :size => 20,:color => @black)
      @tower_nodes4 = Chingu::Text.create(:text => "divides between multiple outputs", :x => 620, :y => 220, :size => 20,:color => @black)
    end

    # Basic setup to draw the tower initially when the mode starts
    def setup
      clear_towers
      draw_tower($tower, @tower_x, @tower_y, @size)
      super
    end

    # Returns the quadrant the mouse is in when hovering over a node in the
    # tower
    def find_mouse_quadrant
      if @y_offset > @x_offset
        ($node_size - @y_offset) > @x_offset ? :W : :S
      else
        ($node_size - @y_offset) > @x_offset ? :N : :E
      end
    end

    # Adds/removes connections
    def toggle_connection
      direction = find_mouse_quadrant
      return unless @x_coord.between?(0, $tower.x-1) && @y_coord.between?(0, $tower.y-1)
      if $tower.grid.connected?(@x_coord, @y_coord, direction)
        $tower.grid.remove_connection(@x_coord, @y_coord, direction)
      else
        $tower.grid.create_connection(@x_coord, @y_coord, direction)
      end
      clear_towers
      draw_tower($tower, @tower_x, @tower_y, @size)
    end

    # Switches a node's type to the next type in the list
    def edit_node_type
      if (@x_coord > 0 || @y_coord > 0) && (@x_coord < $tower.x && @y_coord < $tower.y)
        $tower.grid.set_type(@x_coord, @y_coord, @types[$tower.grid.get_type(@x_coord, @y_coord)])
      end
      clear_towers
      draw_tower($tower, @tower_x, @tower_y, @size)
      @cost = $tower.cost
    end

    # Draws a light blue indicator for mouse-over when drawing new connections
    def draw_mouse_hover_connection
      HoverConnector.destroy_all
      if @x_coord.between?(0,$tower.x-1) && @y_coord.between?(0,$tower.y-1)
        direction = find_mouse_quadrant
        draw_x = @x_coord * $node_size + $node_size/2
        draw_y = @y_coord * $node_size + $node_size/2
        @angle ||= {:N => 0,:S => 180, :E => 90, :W => 270}
        HoverConnector.create(:x => draw_x, :y => draw_y, :angle => @angle[direction], :factor_x => $size, :factor_y => $size)
      end
    end

    # Updates ouse position and overlays
    def update
      super
      @m_x, @m_y = $window.mouse_x, $window.mouse_y
      @x_offset = (@m_x + @tower_x) % $node_size
      @y_offset = (@m_y + @tower_y) % $node_size
      @x_coord = ((@m_x + @tower_x)/$node_size).to_int
      @y_coord = ((@m_y + @tower_y)/$node_size).to_int
      draw_mouse_hover_connection
      @cost_display.text = "Current tower cost: #{@cost}"
      $window.caption = "Tower Edit Mode. FPS #{$window.fps}"
    end
  end
end
