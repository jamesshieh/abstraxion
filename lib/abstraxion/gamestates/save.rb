module Abstraxion
  class Save < SaveLoadMenu

    include GameStateHelper

    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to save to:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => :exit,
                      :left_mouse_button => :save_state,
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

