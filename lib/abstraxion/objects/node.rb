module Abstraxion
  class Charge < GameObject
    def initialize(options = {})
      @zorder = 20
      super(options.merge(:image => Image["charge.png"]))
    end
  end

  class Node < GameObject
    def initialize(options = {}, type)
      @zorder = 8
      super(options.merge(:image => Image[type.to_s + ".png"]))
    end
  end
end
