module GameWrapper
  # Wrapper object for the entire game state
  class GameObj
    attr_accessor :tower, :generator, :map
    def initialize
      @tower = []
      @generator = MapAbxn::Generator.new
      @map = MapAbxn::Map.new
    end

    def add_tower(tower)
      @tower << tower
    end

    def remove_tower
    end
  end
end


