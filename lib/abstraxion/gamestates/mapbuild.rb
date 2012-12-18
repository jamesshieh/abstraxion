module Abstraxion
  class MapBuild < Play
    def initialize
      super
      self.input = {  :escape => Play,
                      :m => Play
      }
    end

    def build_tower
    end

    def setup
      @cell = MapCellHover.create(:x => 0, :y => 0)
      super
    end

    def update
      super
    end
  end
end

