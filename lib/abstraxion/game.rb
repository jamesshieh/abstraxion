module GameWrapper
  # Wrapper object for the entire game state
  class GameObj
    attr_accessor :tower_cells, :generator, :map, :tower1, :tower2, :tower3, :tower4, :tower5, :wall
    def initialize
      @tower_cells = []
      @tower1 = MapAbxn::Tower.new(5, 5)
      @tower2 = MapAbxn::Tower.new(5, 5)
      @tower3 = MapAbxn::Tower.new(5, 5)
      @tower4 = MapAbxn::Tower.new(5, 5)
      @tower5 = MapAbxn::Tower.new(5, 5)
      @generator = MapAbxn::Generator.new
      @wall = MapAbxn::Wall.new
      @map = Map::Map.new
    end

    def add_tower(tower)
      @tower_cells << tower
    end

    # TODO: add a way to remove specific towers
    def remove_tower
    end
  end
end


