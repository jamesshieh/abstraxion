module Abstraxion
  class InConnector < GameObject
    def initialize(options = {})
      super(options.merge(:image => Image["inconnection.png"]))
      self.zorder = ZOrder::Connector
    end
  end

  class OutConnector < GameObject
    def initialize(options = {})
      super(options.merge(:image => Image["outconnection.png"]))
      self.zorder = ZOrder::Connector
    end
  end

  class HoverConnector < GameObject
    def initialize(options = {})
      super(options.merge(:image => Image["hoverconnection.png"]))
      self.zorder = ZOrder::Hover
    end
  end
end
