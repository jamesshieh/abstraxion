module TowerAbxn

  OPPOSITE_NODES = { :N => :S, :S => :N, :E => :W, :W => :E }

  class Grid
    attr_accessor :grid, :grid_iterator, :x, :y
    def initialize(x, y)
      @x, @y = x, y
      @pulses = []
      @originator = Originator.new(id.resume)
      @current_id = 0
      @id ||= id
      @grid ||= generate_grid
      @grid[0][0] = @originator # NOTE: Temp setting
      set_neighbors
    end

    # Enumerator object to iterate over nodes
    def grid_iterator
      Enumerator.new do |x|
        @grid.each do |row|
          row.each do |col|
            x << col
          end
        end
      end
    end

    # Marshal dump function for saving to external function
    def marshal_dump
      [@x, @y, @originator, @grid, @current_id, @pulses]
    end

    # Marshal load function for loading from file
    def marshal_load array
      @x, @y, @originator, @grid, @current_id, @pulses = array
    end

    # Generator for node IDs
    def id
      Fiber.new do
        id = @current_id
        loop do
          Fiber.yield id
          id += 1
        end
      end
    end

    # Method that creates the grid initially
    def generate_grid
      grid = []
      @y.times do
        row = []
        @x.times do
          row << Node.new(@id.resume)
        end
        grid << row
      end
      grid
    end

    # Method that sets pointers to neighboring nodes in the grid
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

    # Returns connection status
    def connected?(x, y, direction)
      @grid[y][x].connected?(direction)
    end

    # Creates a new connection if a neighbor exists
    def create_connection(x, y, direction)
      @grid[y][x].connect(direction)
    end

    # Removes the entire connection between two nodes
    def remove_connection(x, y, direction)
      @grid[y][x].disconnect(direction)
    end

    # Returns the node type
    def get_type(x, y)
      @grid[y][x].type
    end

    # Sets the node type
    def set_type(x, y, type)
      @grid[y][x].set_type(type)
    end

    # Gets a pulse from the generator and sends it to grid
    def pulse(pulse)
      @originator.generator_receive_pulse(pulse)
    end

    # Resets tower to have no pulses
    def reset_pulses
      grid_iterator.each do |node|
        node.clear_buffer
      end
    end

    # Steps the pulses in the tower forward one node
    def update
      grid_iterator.each do |node|
        pulse = node.send_pulse
        @pulses << pulse if !pulse.nil?
      end
      grid_iterator.each do |node|
        node.clear_buffer
      end
      @pulses
    end
  end

  # Base Node class
  class Node

    attr_accessor :neighbors, :id, :pulses, :connections, :pulse_buffer, :nodeabxn

    include PulseEngine

    def initialize(id)
      @id = id
      @nodeabxn = NodeAbxn::Molecule.new #TODO: this must inherit properties from the node class that was created
      @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
      @connections = { :N=>0, :S=>0, :E=>0, :W=>0 }
      @pulses = []
      @pulse_buffer = []
    end

    # Returns if the node is connected to a neighbor
    def connected?(direction)
      @nodeabxn.conn[direction] == 1 || @nodeabxn.conn[direction] == 2
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
      if !@pulses.empty?
        pulse = aggregate_pulses(@pulses)
        instruct = @nodeabxn.send_and_receive_pulse(pulse)
        instruct.each do |direction, pulse|
          pulse.set_direction(direction)
          @neighbors[direction].receive_pulse(pulse)
        end
      end
      nil
    end

    # TODO: Temporary set type for node
    def set_type(type)
      @nodeabxn.type = type
    end

    # Returns the node abstraction's type
    def type
      @nodeabxn.type
    end

    # Connect a neighbor
    def connect(direction)
      inverse = OPPOSITE_NODES[direction]
      if !@neighbors[direction].nil?
        @nodeabxn.conn[direction] = 1
        @connections[direction] = 1
        @neighbors[direction].connections[inverse] = 2 if @neighbors[direction].connections[inverse] == 0
      end
    end

    # Disconnect a neighbor
    def disconnect(direction)
      inverse = OPPOSITE_NODES[direction]
      if !@neighbors[direction].nil?
        @nodeabxn.conn[direction] = 0
        @connections[direction] = 0
        @neighbors[direction].connections[inverse] = 0
        @neighbors[direction].nodeabxn.conn[inverse] = 0
      end
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

    # Special type return for originator
    def type
      :originator
    end

    # Send pulses to neighbors and out of system back to tower
    def send_pulse
      if !@zero_pulse.nil?
        instruct = @nodeabxn.send_and_receive_pulse(@zero_pulse)
        instruct.each do |direction, pulse|
          pulse.set_direction(direction)
          @neighbors[direction].receive_pulse(pulse)
        end
        @zero_pulse = nil
      end
      if !@pulses.empty?
        pulse = aggregate_pulses(@pulses)

        pulse
      end
    end
  end
end
