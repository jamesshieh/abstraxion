# Class and methods to work with Pulses
module PulseEngine

  class Pulse
    attr_accessor :amplitude
    def initialize(amplitude = 1.0)
      @amplitude = amplitude
    end
  end

  def amplify(magnitude)
    @amplitude = @amplitude * magnitude
  end

  def aggregate_pulses(pulses)
    amplitude = 0
    amplitude += pulses.pop.amplitude until pulses.empty?
    Pulse.new(amplitude)
  end
end
