module Abstraxion
  class Charge < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Charge
      super(options.merge(:image => Image["charge.png"]))
    end
  end

  class Node < GameObject
    def initialize(options = {}, type)
      self.zorder = ZOrder::Node
      super(options.merge(:image => Image[type.to_s + ".png"]))
    end
  end
end
