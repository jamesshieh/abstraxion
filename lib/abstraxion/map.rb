module Map
  class Map
    attr_reader :x, :y

    include GridHelper

    def initialize
      @x = 20
      @y = 12
      @grid ||= generate_grid
      @generator_flag ||= false
    end

    def generator?
      @generator_flag
    end

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

    def marshal_dump
      [@x, @y, @grid, @generator_pointer]
    end

    def marshal_load array
      @x, @y, @grid, @generator_pointer = array
    end

    def get_cell(x, y)
      @grid[y][x]
    end

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

    def delete_object(x, y)
      @generator_flag = false if @grid[y][x].object.class == MapAbxn::Generator
      @grid[y][x] = nil
    end

    def get_type(x, y)
      if @grid[y][x].nil?
        return nil
      else
        return @grid[y][x].object.class
      end
    end

    def occupied_spaces
      objects = []
      grid_iterator.each do |cell|
        objects << cell unless cell.nil?
      end
      objects
    end
  end

  class Cell
    attr_accessor :x, :y, :object
    def initialize(x, y, object)
      @x = x
      @y = y
      @object = object
    end
  end
end

