module AI
  class AStarAlgorithm
    def initialize(map_grid, end_node, start_node = [19,6])
      @end_x, @end_y = end_node
      @start_x, @start_y = start_node
      @flagged_grid ||= generate_flagged_grid(map_grid)
      @y = @flagged_grid.length
      @x = @flagged_grid[0].length
    end

    def generate_flagged_grid(map_grid)
      flagged_grid = []
      map_grid.each_with_index do |row, y|
        temp = []
        row.each_with_index do |cell, x|
          cell.nil? ? temp << Node.new(1,[x,y],[@end_x, @end_y]) : temp << Node.new(0,[x,y],[@end_x, @end_y])
        end
        flagged_grid << temp
      end
      flagged_grid
    end

    # Find the shortest path with AStar
    def astar
      set_neighbors
      open = PriorityQueue.new
      closed = PriorityQueue.new
      start = @flagged_grid[@start_y][@start_x]
      start.set_parent(:start)
      start.g_score(0)
      open.push(start)
      while !open.empty?
        current = open.find_and_pop_best
        if (current.x == @end_x) && (current.y == @end_y)
          return retrace_path(current)
        end
        closed.push(current)
        current.neighbors.each do |neighbor|
          if closed.find(neighbor).nil?
            neighbor.set_parent(current)
            neighbor.g_score(current.g)
            open.push(neighbor)
          else
            if (current.g + neighbor.cost) <= neighbor.g
              neighbor.set_parent(current)
              neighbor.g_score(current.g)
            end
          end
        end
      end
    end

    # Retrace and generate path
    def retrace_path(current)
      path = []
      while current.parent != :start
        previous = current.parent
        ew = current.x - previous.x
        ns = current.y - previous.y
        case ew
        when -1
          path << :W
        when 1
          path << :E
        end if ew != 0
        case ns
        when -1
          path << :N
        when 1
          path << :S
        end if ns != 0
        current = previous
      end
      path
    end

    # Method that sets pointers to neighboring nodes in the grid
    def set_neighbors
      for i in (0..@x-1)
        for j in (0..@y-1)
          node = @flagged_grid[j][i]
          node.set_n(@flagged_grid[j-1][i]) if j > 0 && node.cost > 0
          node.set_s(@flagged_grid[j+1][i]) if j < @y - 1 && node.cost > 0
          node.set_e(@flagged_grid[j][i+1]) if i < @x - 1 && node.cost > 0
          node.set_w(@flagged_grid[j][i-1]) if i > 0 && node.cost > 0
        end
      end
    end
  end

  class PriorityQueue
    def initialize(nodes = [])
      @nodes = nodes
    end

    def empty?
      @nodes.empty?
    end

    def push(obj)
      @nodes << obj
    end

    def find_and_pop_best
      min = @nodes[0]
      @nodes.each do |node|
        if node.f < min.f
          min = node
        end
      end
      pop(min)
    end

    def find(node)
      @nodes.find {|x| x == node}
    end

    def pop(node)
      @nodes.delete(find(node))
    end
  end

  class Node
    attr_reader :x, :y, :n, :s, :e, :w, :cost, :g, :h, :f, :parent
    def initialize(cost,coords,goal)
      @cost = cost
      @x, @y = coords
      @gx, @gy = goal
      @g = 9999
      @h = (@x - @gx).abs + (@y - @gy).abs
      @f = @g + @h
      @n = nil
      @s = nil
      @e = nil
      @w = nil
      @parent = nil
    end
    def neighbors
      [@n,@s,@e,@w].select { |x| !x.nil? }
    end
    def set_parent(node)
      @parent = node
    end
    def g_score(previous_g)
      @g = previous_g + @cost
      @f = @g + @h
    end

    def set_n(neighbor)
      @n = neighbor
    end

    def set_s(neighbor)
      @s = neighbor
    end

    def set_e(neighbor)
      @e = neighbor
    end

    def set_w(neighbor)
      @w = neighbor
    end
  end
end



