module Abstraxion
  class GameOver < Chingu::GameState
    def initialize(options = {})
      super
      @color = Gosu::Color.new(200,0,0,0)
      self.input = { :escape => :exit,
      }
      @font = Gosu::Font[50]
      @text = "Your Generator has died! GAME OVER!"
    end

    def draw
      previous_game_state.draw

      $window.draw_quad(0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER)
      @font.draw(@text, 100, $window.height/2 - 100, Chingu::DEBUG_ZORDER)
    end
  end
end

