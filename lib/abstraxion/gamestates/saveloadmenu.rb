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

    # Load the screen and previews
    def setup
      super
      clear_towers
      load_previews
      @savedt1, @savedt2, @savedt3 = @saved_towers.values
      draw_cursor
      @save1 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 2 * WINDOW_H/7)
      draw_tower(@savedt1, 255, 2 * WINDOW_H/7 - $node_size * @savedt1.y / 2, @size) unless @savedt1.nil?
      @save2 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 4 * WINDOW_H/7)
      draw_tower(@savedt2, 255, 4 * WINDOW_H/7 - $node_size * @savedt2.y / 2, @size) unless @savedt2.nil?
      @save3 ||= SaveSlot.create(:x => WINDOW_W/2, :y => 6 * WINDOW_H/7)
      draw_tower(@savedt3, 255, 6 * WINDOW_H/7 - $node_size * @savedt3.y / 2, @size) unless @savedt3.nil?
    end
  end
end

