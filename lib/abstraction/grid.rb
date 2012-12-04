module TowerLevel
  class Grid
    attr_accessor :grid, :grid_iterator, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @pulses = []
      @id ||= id
      @grid ||= generate_grid
      @grid_iterator = Enumerator.new do |x|
        @grid.each do |row|
          row.each do |col|
            x << col
          end
        end
      end
    end

    def create_node(x, y, type)
      @grid[y][x] = GridLevel::Node.new(id)
    end

    def id
      Fiber.new do
        id = 0
        loop do
          Fiber.yield id
          id += 1
        end
      end
    end

    def generate_grid
      grid = []
      @y.times do
        row = []
        @x.times do
          row << GridLevel::Basic.new(@id.resume)
        end
        grid << row
      end
      grid
    end

    def set_neighbors
      for i in (0..@x-1)
        for j in (0..@y-1)
          n = @grid[j][i].neighbors
          n[:N] = @grid[j-1][i] if j > 0
          n[:S] = @grid[j+1][i] if j < @y - 1
          n[:E] = @grid[j][i+1] if i < @x - 1
          n[:W] = @grid[j][i-1] if i > 0
        end
      end
    end

    def create_connection(x, y, direction)
      @grid[y][x].connect(direction)
    end

    def remove_connection(x, y, direction)
      @grid[y][x].disconnect(direction)
    end

    def step
      @grid_iterator.each do |node|
        pulse = node.send_pulse
        @pulses << pulse if !pulse.nil?
      end
      @grid_iterator.each do |node|
        node.clear_buffer
      end
      @pulses
    end

  end
end
