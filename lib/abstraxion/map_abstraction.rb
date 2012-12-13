module MapAbxn

  class Generator
    def initialize(delay, tower, hp = 1000)
      @delay = delay
      @hp = hp
      @tower = tower # temporary pointer to tower before wiring is enabled on the map level
    end

    def generate_pulse
      @gen ||= Fiber.new do
        wait = 0
        loop do
          if wait == @delay
            wait = 0
            Fiber.yield PulseEngine::Pulse.new
          else
            wait += 1
            Fiber.yield
          end
        end
      end
    end

    def alive?
      @hp > 0
    end

    def update
      pulse = generate_pulse.resume
      @tower.pulse(pulse) if pulse
    end
  end

  class Tower
    attr_accessor :grid, :pulses, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @grid = TowerAbxn::Grid.new(x, y)
      @pulses = []
    end

    def reset
      @grid.reset_pulses
    end

    def pulse(pulse)
      @grid.pulse(pulse)
    end

    def update
      @grid.update
    end
  end

end
