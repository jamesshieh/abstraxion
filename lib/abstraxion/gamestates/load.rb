module Abstraxion
  class Load < SaveLoadMenu

    def initialize
      super
      @title = Chingu::Text.create(:text => "Choose which slot to load from:", :x => 10, :y => 10, :size => 50)
      self.input = {  :escape => TowerEdit,
                      :left_mouse_button => :load_state
      }
    end
  end
end

