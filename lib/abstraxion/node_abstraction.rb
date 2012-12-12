module NodeAbxn
  class Molecule
    attr_accessor :type, :conn
    def initialize(conn = {},type = :basic)
      @type = type # TODO: Temporary skip for this level of abx
      @conn = conn # TODO: Temporary skip for this level of abx
    end
    def send_and_receive_pulse(pulse)
      # TODO: Temporary skips for this level of abx
      outbound = {}
      connections = []
      @conn.each { |k, v| connections << k if v == 1 }
      if !connections.empty?
        case type
        when :amplifier
          outbound[connections[0]] = pulse.amplify(1.5)
        when :splitter
          connections.each do |x|
            outbound[x] = PulseEngine::Pulse.new(pulse.amplitude/connections.length)
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
  end
  class Atom
    def initialize(id)
      @id = id
      @neighbors = {:N=>nil, :S=>nil, :E=>nil, :W=>nil}
      @out_conn = nil
      @connections = { :N=>0, :S=>0, :E=>0, :W=>0 }
      @pulse = nil
    end


  end

  class Battery < Atom
  
  end
  class Amplifier < Atom
  end
  class Prism < Atom
  end
  class Polarizer < Atom
  end
  class Reflector < Atom
  end
  class Refractor < Atom
  end
end

