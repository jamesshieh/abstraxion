module MapAbxn
  # A map level generator that creates pulses in set intervals
  class Generator
    def initialize(delay, tower, hp = 1000)
      @delay = delay
      @hp = hp
      @tower = tower # temporary pointer to tower before wiring is enabled on the map level
    end

    # Generates a new pulse
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

    # Returns if the generator is alive
    def alive?
      @hp > 0
    end

    # Steps the generator forward and pulses if needed
    def update
      pulse = generate_pulse.resume
      @tower.pulse(pulse) if pulse
    end
  end

  # A map level tower
  class Tower
    attr_accessor :grid, :pulses, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @grid = TowerAbxn::Grid.new(x, y)
      @pulses = []
    end

    # Resets all pulses in the tower
    def reset
      @grid.reset_pulses
    end

    # Sends a pulse into the grid
    def pulse(pulse)
      @grid.pulse(pulse)
    end

    # Steps the tower forward
    def update
      @grid.update
    end
  end

end
