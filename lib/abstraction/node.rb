# Base Node class
class Node

  attr_accessor :neighbors, :id, :out_conn, :pulses

  include PulseEngine

  def initialize(id)
    @id = id
    @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
    @out_conn = nil
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

end

# Multiple outbound connection Node superclass
class MultiNode < Node

  # Connect a neighbor
  def connect(direction)
    @out_conn ||= {:N=>0, :S=>0, :E=>0, :W=>0}
    @out_conn[direction] = 1
  end

  # Disconnect a neighbor
  def disconnect(direction)
    @out_conn[direction] = 0
  end
end

# Single outbound connection Node superclass
class SingleNode < Node

  # Only allow one connection at a time for basic nodes
  def connect(direction)
    @out_conn = @neighbors[direction]
  end
end

# Generator node, creates new pulses and sends received pulses to the next
# level of abstraction
class Generator < SingleNode
  def send_pulse
    generate_pulse
    if !@pulses.empty?
      pulse = aggregate_pulses(@pulses)

      return pulse
    end
  end

  def generate_pulse
    puts "Generating new pulse"
    @out_conn.receive_pulse(Pulse.new) unless @out_conn.nil?
    puts "Pulse sent to #{out_conn.id}"
    nil
  end

end

# Splitter, splits a single pulse into multiple weaker pulses
class Splitter < MultiNode
  def send_pulse
    if !@pulses.empty?
      pulse = aggregate_pulses(@pulses)

      connections ||= @out_conn.select{ |key, value| key if value == 1 }
      connections.each do |key, value|
        split_pulse = pulse.amplitude / connections.length if connections.length > 1
        @neighbors[key].receive_pulse(Pulse.new(split_pulse))
      end
    end
    nil
  end
end

# Amplifier, multiples the amplitude of received pulses
class Amplifier < SingleNode
  def initialize(id)
    super(id)
    @multiplier = 1.5
  end

  def set_multiplier(value)
    @multiplier = (value)
  end

  def send_pulse
    if !@pulses.empty?
      pulse = aggregate_pulses(@pulses)
      amplified = pulse.amplitude * @multiplier

      @out_conn.receive_pulse(Pulse.new(amplified)) unless @out_conn.nil?
    end
    nil
  end
end

# Switcher, sends single pulses to different connections in turn
class Switcher < MultiNode
  def send_pulse
    if !@pulses.empty?
      pulse = aggregate_pulses(@pulses)

      connections ||= @out_conn.select{ |key, value| key if value == 1 }
      @switch_length ||= connections.length
      target = connections.keys[next_switch]

      @neighbors[target].receive_pulse(Pulse.new(pulse.amplitude)) unless connections.empty?
    end
    nil
  end

  def next_switch
    @switch = 0
    @switch = (@switch + 1) % @switch_length
  end

end

# Basic, passes pulses on to next node
class Basic < SingleNode
  def send_pulse
    if !@pulses.empty?
      pulse = aggregate_pulses(@pulses)

      @out_conn.receive_pulse(Pulse.new(pulse.amplitude)) unless @out_conn.nil?
    end
    nil
  end
end
