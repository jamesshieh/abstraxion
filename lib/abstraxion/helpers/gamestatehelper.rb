module GameStateHelper
  # World play map drawing grid
  def draw_map
    draw_map_cells($map.x, $map.y)
  end

  # Draw empty map cells in a XxY grid
  def draw_map_cells(x, y)
    for i in (0..x-1)
      for j in (0..y-1)
        MapCellEmpty.create(:x => $node_size*5 * i + $node_size *5/2.0, :y => $node_size * 5 * j + $node_size * 5/2.0)
      end
    end
  end

  # Create cursor
  def draw_cursor
    $cursor = Cursor.create(:x => $window.mouse_x, :y=>$window.mouse_y)
  end

  # Iterate through grid and draw charges where they exist
  def draw_charges
    Charge.destroy_all
    $tower.grid.grid_iterator.each_with_index do |node, i|
      draw_charge(i % $tower.y, i / $tower.y) if !node.pulses.empty?
    end
  end

  # Draws a charge in a specific node
  def draw_charge(x, y)
    draw_x = x*$node_size + $node_size/2
    draw_y = WINDOW_H / 2 - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
    Charge.create(:x => draw_x, :y => draw_y, :factor_x => @size, :factor_y => @size)
  end

  # Clears all tower objects
  def clear_towers
    Node.destroy_all
    OutConnector.destroy_all
    InConnector.destroy_all
  end

  # Draw tower
  def draw_tower(tower, dx, dy, scale)
    tower.grid.grid_iterator.each_with_index do |node, i|
      draw_node(dx, dy, i % tower.y, i / tower.y, node.connections, node.type, scale)
    end
  end

  # Draw a specific node and the special connector types between nodes
  def draw_node(dx, dy, x, y, connections, type, scale)
    draw_x = dx + x*$node_size + $node_size/2
    draw_y = dy - 0.5 * $tower.y * $node_size + y*$node_size + $node_size/2
    Node.create({:x => draw_x, :y => draw_y, :factor_x => scale, :factor_y => scale}, type)
    n, s, e, w = connections.values
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => scale, :factor_y => scale) if n == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => scale, :factor_y => scale) if s == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => scale, :factor_y => scale) if e == 1
    OutConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => scale, :factor_y => scale) if w == 1
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 0, :factor_x => scale, :factor_y => scale) if n == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 180, :factor_x => scale, :factor_y => scale) if s == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 90, :factor_x => scale, :factor_y => scale) if e == 2
    InConnector.create(:x => draw_x, :y => draw_y,:angle => 270, :factor_x => scale, :factor_y => scale) if w == 2
  end
end

