module MapAbxn

  # A map level generator that creates pulses in set intervals
  class Generator
    attr_reader :hp, :maxhp, :exp_left, :level, :connections

    def initialize(delay = 4)
      @delay = delay
      @hp = 100.0
      @maxhp = @hp
      @level = 1
      @exp_left = 5
      @connections = { 0 => nil }
    end

    # Default connection
    def default_connection
      open_connections = @connections.select{|k,v| v.nil?}.keys
      if open_connections.empty?
        rand(0..@connections.length-1)
      else
        open_connections[0]
      end
    end

    def status
      [@hp, @maxhp]
    end

    # Take a hit worth x damage
    def hit(damage)
      @hp -= damage
    end

    # Gain experience
    def gain_exp(exp)
      @exp_left -= exp
      if @exp_left < 0
        level_up
        @exp_left = 5 + @level * 3
      end
    end

    # Level up the generator, each level adds one possible connection
    def level_up
      @level += 1
      @maxhp = 100 + @level * 12
      @hp = @maxhp
      @connections[@level/5] = nil if @level % 5 == 0
    end

    # Connect tower to the generator
    def connect_tower(tower, output_number)
      @connections[output_number] = tower
    end

    # Kill the connection from that output node
    def kill_connection(output_number)
      @connections[output_number] = nil
    end

    # Marshal dump func for saving
    def marshal_dump
      [@delay, @hp, @maxhp, @level, @connections, @exp_left]
    end

    # Marshal load func for loading
    def marshal_load array
      @delay, @hp, @maxhp, @level, @connections, @exp_left = array
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

    # TODO: need to add mechanism to pulse to multiple connections and see who
    # gets what pulses
    # Steps the generator forward and pulses if needed
    def update
      pulse = generate_pulse.resume
      @connections.values.each do |connection|
        connection.pulse(PulseEngine::Pulse.new) if pulse && !connection.nil?
      end
    end
  end

  # Wall object
  class Wall
    def initialize
      @hp = 100
    end
  end

  # A map level tower
  class Tower
    attr_accessor :grid, :pulses, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @grid = TowerAbxn::Grid.new(x, y)
    end

    def cost
      @grid.cost
    end

    def marshal_load array
      @x, @y, @grid = array
    end

    def marshal_dump
      [@x, @y, @grid]
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
