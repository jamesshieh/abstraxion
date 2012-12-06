require_relative 'pulse'
module TowerAbxn

  OPPOSITE_NODES = { :N => :S, :S => :N, :E => :W, :W => :E }

  class Grid
    attr_accessor :grid, :grid_iterator, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @pulses = []
      @originator = Originator.new(id.resume)
      @grid ||= generate_grid
      @grid[0][0] = @originator
      @grid_iterator = Enumerator.new do |x|
        @grid.each do |row|
          row.each do |col|
            x << col
          end
        end
      end
    end

    def id
      Fiber.new do
        id = 0
        loop do
          Fiber.yield id
          id += 1
        end
      end
    end

    def generate_grid
      grid = []
      @y.times do
        row = []
        @x.times do
          row << Node.new(id.resume)
        end
        grid << row
      end
      grid
    end

    def set_neighbors
      for i in (0..@x-1)
        for j in (0..@y-1)
          n = @grid[j][i].neighbors
          n[:N] = @grid[j-1][i] if j > 0
          n[:S] = @grid[j+1][i] if j < @y - 1
          n[:E] = @grid[j][i+1] if i < @x - 1
          n[:W] = @grid[j][i-1] if i > 0
        end
      end
    end

    def create_connection(x, y, direction)
      @grid[y][x].connect(direction)
    end

    def remove_connection(x, y, direction)
      @grid[y][x].disconnect(direction)
    end

    def pulse(pulse)
      @originator.generator_receive_pulse(pulse)
    end

    def update
      @grid_iterator.each do |node|
        pulse = node.send_pulse
        @pulses << pulse if !pulse.nil?
      end
      @pulses
    end
  end

  # Base Node class
  class Node

    attr_accessor :neighbors, :id, :out_conn, :pulses, :connections, :pulse_buffer

    include PulseEngine

    def initialize(id)
      @id = id
      @nodeabxn = NodeAbxn::Molecule.new #TODO: this must inherit properties from the node class that was created
      @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
      @out_conn = nil
      @connections = { :N=>0, :S=>0, :E=>0, :W=>0 }
      @pulses = []
      @pulse_buffer = []
    end

    # Dump the buffer into the active pulses
    def clear_buffer
      @pulses, @pulse_buffer = @pulse_buffer, []
    end

    # Receive a pulse and store it in pulses for processing later
    def receive_pulse(pulse)
      @pulse_buffer << pulse
    end

    # Process a pulse and send it on to neighbors
    def send_pulse
      clear_buffer
      if !@pulses.empty?
        pulse = aggregate_pulses(@pulses)
        instruct = @nodeabxn.send_and_receive_pulse(pulse)
        instruct.each do |key, value|
          @neighbors[key].receive_pulse(value) if !value.nil?
        end
      end
      nil
    end

    # TODO: Temporary set type for node
    def set_type(type)
      @nodeabxn.type = type
    end

    def type
      @nodeabxn.type
    end
    # Connect a neighbor
    def connect(direction)
      inverse = OPPOSITE_NODES[direction]
      if !@neighbors[direction.nil?]
        @nodeabxn.conn[direction] = 1
        @connections[direction] = 1
        @neighbors[direction].connections[inverse] = 1
      end
    end

    # Disconnect a neighbor
    def disconnect(direction)
      inverse = OPPOSITE_NODES[direction]
      @nodeabxn.conn[direction] = 0
      @neighbors[direction].connections[inverse] = 0
    end
  end

  # Generator node, creates new pulses and sends received pulses to the next
  # level of abstraction
  # NOTE: pre-abstracted node that cannot be edited from inside? acts as origin
  class Originator < Node
    def initialize(id)
      super(id)
      @zero_pulse = nil
    end

    # Receive a pulse from the generator outside of tower level abstraction
    def generator_receive_pulse(pulse)
      @zero_pulse = pulse
    end

    def type
      :originator
    end

    # Send pulses to neighbors and out of system back to tower
    def send_pulse
      if !@zero_pulse.nil?
        conn =  @nodeabxn.conn.keys[0]
        @neighbors[conn].receive_pulse(@zero_pulse)
        @zero_pulse = nil
      end
      if !@pulses.empty?
        pulse = aggregate_pulses(@pulses)

        return pulse
      end
    end
  end
end
