module GameWrapper
  # Wrapper object for the entire game state
  class GameObj
    attr_accessor :tower, :generator, :map
    def initialize(tower_x, tower_y, gen_delay)
      @tower = MapAbxn::Tower.new(tower_x, tower_y)
      @generator = MapAbxn::Generator.new(gen_delay, @tower)
      @map = MapAbxn::Map.new
    end
  end
end


