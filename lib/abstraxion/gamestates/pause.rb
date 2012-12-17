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
      @font = Gosu::Font[35]
      @text = "PAUSED - press 'ESC' or 'P' to unpause"
      @savemenu = "Press 'S' for save menu"
      @loadmenu = "Press 'L' for load menu"
    end

    def unpause
      pop_game_state(:setup => false)
    end

    def draw
      previous_game_state.draw

      $window.draw_quad(0,0,@color,
                        $window.width,0,@color,
                        $window.width,$window.height,@color,
                        0,$window.height,@color, Chingu::DEBUG_ZORDER)
      @font.draw(@text, $window.width/2, $window.height/2 - 100, Chingu::DEBUG_ZORDER)
      @font.draw(@savemenu, $window.width/2, $window.height/2, Chingu::DEBUG_ZORDER)
      @font.draw(@loadmenu, $window.width/2, $window.height/2 + 50, Chingu::DEBUG_ZORDER)
    end
  end
end

