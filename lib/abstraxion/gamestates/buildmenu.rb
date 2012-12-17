module Abstraxion
  # Building game state where the tower grid can be edited
  class BuildMenu < Build
    def initialize
      super
      self.input = {  :escape => :exit,
                      :space => Build
      }
    end
  end
end
