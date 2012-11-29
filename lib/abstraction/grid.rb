class Grid
  attr_accessor :grid, :grid_iterator
  def initialize(x, y)
    @x, @y = x, y
    @id = 0
    @pulses = []
    @grid ||= generate_grid
    @grid_iterator = Enumerator.new do |x|
      @grid.each do |row|
        row.each do |col|
          x << col
        end
      end
    end
  end

  def generate_grid
    grid = []
    @y.times do
      row = []
      @x.times do
        row << Basic.new(id)
      end
      grid << row
    end
    grid
  end

  def id
    @id += 1
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
