module Abstraxion
  # Superclass with mixins for normal gamestate
  class Master < Chingu::GameState
    def initialize
      super
    end

    # Redraw the tower and cursor everytime a gamestate is loaded
    def setup
      draw_tower
      draw_cursor
      Chingu::GameObject.create(:image => 'background.png', :rotation_center => :top_left, :zorder => 0)
    end

    # Make cursor follow mouse
    def draw_cursor
      $cursor = Cursor.create(:x => $window.mouse_x, :y=>$window.mouse_y)
    end

    # Remove and redraw updated tower
    def draw_tower
      Node.destroy_all
      OutConnector.destroy_all
      InConnector.destroy_all
      $tower.grid.grid_iterator.each_with_index do |node, i|
        draw_node(i % $tower.y, i / $tower.y, node.connections, node.type)
      end
    end

    # Draw a specific node and the special connector types between nodes
    def draw_node(x, y, connections, type)
      draw_x = x*$node_size + $node_size/2
      draw_y = WINDOW_H / 2 - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
      Node.create({:x => draw_x, :y => draw_y, :factor_x => $size, :factor_y => $size}, type)
      n, s, e, w = connections.values
      OutConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => $size, :factor_y => $size) if n == 1
      OutConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => $size, :factor_y => $size) if s == 1
      OutConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => $size, :factor_y => $size) if e == 1
      OutConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => $size, :factor_y => $size) if w == 1
      InConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => $size, :factor_y => $size) if n == 2
      InConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => $size, :factor_y => $size) if s == 2
      InConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => $size, :factor_y => $size) if e == 2
      InConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => $size, :factor_y => $size) if w == 2
    end
  end
end
