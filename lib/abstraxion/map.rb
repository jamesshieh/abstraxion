module Map
  class Map
    attr_reader :x, :y, :grid

    include GridHelper

    # Initialize map size and create empty grid
    def initialize
      @x = 20
      @y = 12
      @grid ||= generate_grid
      @generator_flag ||= false
    end

    # Return the coordinates of a generator if one exists
    def gen_coordinates
      [@gen_x, @gen_y] if generator?
    end

    # Return if a generator has been created in the map
    def generator?
      @generator_flag
    end

    # Create an empty grid x x y in size
    def generate_grid
      grid = []
      @y.times do
        row = []
        @x.times do
          row << nil
        end
        grid << row
      end
      grid
    end

    # Marshal dump class for saving
    def marshal_dump
      [@x, @y, @grid, @generator_pointer]
    end

    # Marshal load class for loading
    def marshal_load array
      @x, @y, @grid, @generator_pointer = array
    end

    # Returns a cell
    def get_cell(x, y)
      @grid[y][x]
    end

    # Creates an object and sets generator flag when generator is created
    def create_object(x, y, object)
      case object
      when MapAbxn::Generator
        delete_object(@gen_x, @gen_y) if generator?
        @gen_x = x
        @gen_y = y
        @grid[y][x] = Cell.new(x, y, object)
        @generator_flag = true
      else
        @grid[y][x] = Cell.new(x, y, object)
      end
    end

    # Delete an object if it exists and flip any flags
    def delete_object(x, y)
      @generator_flag = false if @grid[y][x].object.class == MapAbxn::Generator
      @grid[y][x] = nil
    end

    # Get the type of the cell
    def get_type(x, y)
      if @grid[y][x].nil?
        return nil
      else
        return @grid[y][x].object.class
      end
    end

    # Returns an iterator with only occupied grid spaces
    def occupied_spaces
      objects = []
      grid_iterator.each do |cell|
        objects << cell unless cell.nil?
      end
      objects
    end
  end

  # Cell object that contains coordinates and the object at that location
  class Cell
    attr_accessor :x, :y, :object
    def initialize(x, y, object)
      @x = x
      @y = y
      @object = object
    end
  end
end

