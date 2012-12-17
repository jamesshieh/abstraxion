module Abstraxion
  class Save < SaveLoadMenu

    include GameStateHelper

    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to save to:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => Build,
                      :left_mouse_button => :save_state
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

