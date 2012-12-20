module Abstraxion
  class InConnector < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Connector
      super(options.merge(:image => Image["inconnection.png"]))
    end
  end

  class OutConnector < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Connector
      super(options.merge(:image => Image["outconnection.png"]))
    end
  end

  class HoverConnector < GameObject
    def initialize(options = {})
      self.zorder = ZOrder::Hover
      super(options.merge(:image => Image["hoverconnection.png"]))
    end
  end
end
