module Abstraxion
  class Menu < Chingu::GameState
    def initialize
      super
      @title = Chingu::Text.create(:text => "Abstraxion", :x => WINDOW_W/2 - 300, :y => WINDOW_H/2, :size => 50)
      @prompt = Chingu::Text.create(:text => "Press 'space' to begin", :x => WINDOW_W/2 - 300, :y => WINDOW_H/2 + 100, :size => 30)
      self.input = { :escape => :exit,
                     :space => Play
      }
    end
  end
end
