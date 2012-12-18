module MapAbxn

  # A map level generator that creates pulses in set intervals
  class Generator
    def initialize(delay)
      @delay = delay
      @maxhp = 1000
      @hp = 1000
      @level = 0
      @connections = { 0 => nil }
    end

    def level_up
      @level += 1
      @maxhp = 1000 + @level * 100
      @hp = @maxhp
      @connections[@level] = nil
    end

    def connect_tower(tower, output_number)
      @connections[output_number] = tower
    end

    def kill_connection(output_number)
      @connections[output_number] = nil
    end

    # Marshal dump func for saving
    def marshal_dump
      [@delay, @hp, @level, @connections]
    end

    # Marshal load func for loading
    def marshal_load array
      @delay, @hp, @level, @connections = array
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
      @connections[0].pulse(pulse) if pulse
    end
  end

  # Wall object
  class Wall
    def initialize
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
