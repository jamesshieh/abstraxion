module Abstraxion
  # Save and load superclass
  class SaveLoadMenu < Chingu::GameState

    include GameStateHelper
    include SaveLoadHelper

    def initialize
      super
      @saved_towers = {:save1 => nil, :save2 => nil, :save3 => nil}
      scale = 0.25
      @size = FACTOR * scale
      $node_size = NODE_SIZE * scale
    end
    # Draw the 3 save boxes
    def draw
      super
    end
  end
end

