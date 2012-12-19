module Abstraxion
  class Save < SaveLoadMenu

    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to save to:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => TowerEdit,
                      :left_mouse_button => :save_state
      }
    end
  end
end

