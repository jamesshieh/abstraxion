module NodeAbxn
  # A high level abstraction of node
  class Molecule
    attr_accessor :type, :conn
    def initialize(conn = {},type = :basic)
      @type = type # TODO: Temporary skip for this level of abx
      @conn = conn # TODO: Temporary skip for this level of abx
    end

    # Temporary set processing for each node type
    def send_and_receive_pulse(pulse)
      # TODO: Temporary skips for this level of abx
      outbound = {}
      connections = @conn.select { |_, v| v == 1 }.keys
      if !connections.empty?
        case type
        when :originator
          outbound[connections[0]] = pulse
        when :amplifier
          outbound[connections[0]] = pulse.amplify(1.2)
        when :splitter
          connections.each do |x|
            outbound[x] = PulseEngine::Pulse.new(pulse.amplitude/connections.length * 0.9)
          end
        when :switcher
          @switch ||= (0..connections.length-1).cycle
          outbound[connections[@switch.next]] = pulse
        when :basic
          outbound[connections[0]] = pulse
        end
      end
      outbound
    end

    def marshal_dump
      [@type, @conn]
    end

    def marshal_load(array)
      @type, @conn = array
    end
  end

  # A sub-unit of the node abstraction
  class Atom
    def initialize(id)
      @id = id
      @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
      @out_conn = nil
      @connections = { :N=>0, :S=>0, :E=>0, :W=>0 }
      @pulse = nil
    end
  end
end

