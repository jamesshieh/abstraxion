module Abstraxion
  class Load < SaveLoadMenu

    include GameStateHelper

    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to load from:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => :exit,
                      :left_mouse_button => :load_state,
                      :space => Play
      }
    end

    def draw
      super
    end

    def update
      super
    end
  end
end

