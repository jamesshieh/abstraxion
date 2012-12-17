module Abstraxion
  class SaveSlot < Chingu::GameObject

    include ObjectHelper

    def initialize(options = {})
      super(options.merge(:image => Image["save.png"]))
      @zorder = 100
    end

    def update
      mouse_hover? ? @image = Image["savehover.png"] : @image = Image["save.png"]
    end
  end
end
