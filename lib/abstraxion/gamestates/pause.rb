module Abstraxion
  class Pause < Chingu::GameStates
    def initialize(options = {})
      super
    end
    def draw
      previous_game_state.draw
    end
  end
end

