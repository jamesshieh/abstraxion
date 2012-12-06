module MapAbxn

  class Generator
    def initialize(delay, tower)
      @delay = delay
      @tower = tower # temporary pointer to tower before wiring is enabled on the map level
    end

    def generate_pulse
      Fiber.new do
        wait = 0
        loop do
          if wait == @delay
            Fiber.yield PulseEngine::Pulse.new
          else
            wait += 1
            Fiber.yield
          end
        end
      end
    end

    def update
      pulse = generate_pulse.resume
      @tower.pulse(pulse) if pulse
    end
  end

  class Tower
    attr_accessor :grid, :pulses
    def initialize(x, y)
      @grid = TowerLevel::Grid.new(x, y)
      @pulses = []
    end

    def pulse(pulse)
      @grid.pulse(pulse)
    end

    def update
      Fiber.new do
        loop do
          Fiber.yield @grid.update
        end
      end
    end
  end

end
