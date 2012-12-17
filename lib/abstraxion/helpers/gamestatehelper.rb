module GameStateHelper
  # Make cursor follow mouse
  def draw_cursor
    $cursor = Cursor.create(:x => $window.mouse_x, :y=>$window.mouse_y)
  end

  # Clears all tower objects
  def clear_towers
    Node.destroy_all
    OutConnector.destroy_all
    InConnector.destroy_all
  end

  # Remove and redraw updated tower
  def draw_tower(tower, dx, dy, scale)
    tower.grid.grid_iterator.each_with_index do |node, i|
      draw_node(dx, dy, i % tower.y, i / tower.y, node.connections, node.type, scale)
    end
  end

  # Draw a specific node and the special connector types between nodes
  def draw_node(dx, dy, x, y, connections, type, scale)
    draw_x = dx + x*$node_size + $node_size/2
    draw_y = dy - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
    Node.create({:x => draw_x, :y => draw_y, :factor_x => scale, :factor_y => scale, :zorder => 99}, type)
    n, s, e, w = connections.values
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => scale, :factor_y => scale, :zorder => 100) if n == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => scale, :factor_y => scale, :zorder => 100) if s == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => scale, :factor_y => scale, :zorder => 100) if e == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => scale, :factor_y => scale, :zorder => 100) if w == 1
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => scale, :factor_y => scale, :zorder => 100) if n == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => scale, :factor_y => scale, :zorder => 100) if s == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => scale, :factor_y => scale, :zorder => 100) if e == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => scale, :factor_y => scale, :zorder => 100) if w == 2
  end
end

