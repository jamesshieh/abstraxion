module Abstraxion
  # Superclass with mixins for normal gamestate
  class Master < Chingu::GameState

    include GameStateHelper

    def initialize
      super
    end

    # Redraw the tower and cursor everytime a gamestate is loaded
    def setup
      draw_tower
      draw_cursor
      Chingu::GameObject.create(:image => 'background.png', :rotation_center => :top_left, :zorder => 0)
    end
  end
end
