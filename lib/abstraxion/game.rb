module GameWrapper
  # Wrapper object for the entire game state
  class GameObj
    attr_accessor :tower, :generator, :map
    def initialize
      @tower = []
      @generator = MapAbxn::Generator.new
      @map = MapAbxn::Map.new
    end

    # Add a tower to the array of towers on the map
    def add_tower(tower)
      @tower << tower
    end

    # TODO: add a way to remove specific towers
    def remove_tower
    end
  end
end


