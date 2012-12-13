module Abstraxion
  class InConnector < GameObject
    def initialize(options = {})
      @zorder = 9
      super(options.merge(:image => Image["inconnection.png"]))
    end
  end

  class OutConnector < GameObject
    def initialize(options = {})
      @zorder = 9
      super(options.merge(:image => Image["outconnection.png"]))
    end
  end

  class HoverConnector < GameObject
    def initialize(options = {})
      @zorder = 50
      super(options.merge(:image => Image["hoverconnection.png"]))
    end
  end
end
