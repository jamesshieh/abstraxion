module Abstraxion
  # Building game state where the tower grid can be edited
  class TowerEditMenu < Build
    def initialize
      super
      self.input = {  :escape => :exit,
                      :space => TowerEdit
      }
    end
  end
end
