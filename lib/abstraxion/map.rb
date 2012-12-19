module Map
  class Map
    attr_reader :x, :y

    include GridHelper

    def initialize
      @x = 20
      @y = 12
      @grid ||= generate_grid
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
      [@x, @y, @grid]
    end

    def marshal_load array
      @x, @y, @grid = array
    end

    def create_object(x, y, object)
      @grid[y][x] = Cell.new(x, y, object)
    end

    def delete_object(x, y)
      @grid[y][x] = nil
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

