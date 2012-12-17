module GameWrapper
  # Wrapper object for the entire game state
  class GameObj
    attr_accessor :tower, :generator
    def initialize(tower_x, tower_y, gen_delay)
      @tower = MapAbxn::Tower.new(tower_x, tower_y)
      @generator = MapAbxn::Generator.new(gen_delay, @tower)
    end
  end
end


