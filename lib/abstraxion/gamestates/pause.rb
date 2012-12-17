module Abstraxion
  class Pause < Chingu::GameState
    def initialize(options = {})
      super
      @color = Gosu::Color.new(200,0,0,0)
      self.input = { :escape => :unpause,
                     :p => :unpause,
                     :s => Save,
                     :l => Load
      }
    end

    def unpause
      pop_game_state(:setup => false)
    end

    def draw
      previous_game_state.draw

      $window.draw_quad(0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color)
    end
  end
end

